require 'pstore'
require 'yaml/store'

class PObject
  # When `allow_missing` is called at the inheriting class level, then
  # all calls to any missing attribute will return `nil` and supress the 
  # normal ruby behavior of raising a `NoMethodError`.
  def self.allow_missing
    send :define_method, :allow_missing? do
      true
    end
  end

  # Intercept any call to an unknown method, and try to load it from the
  # store. If it does not exist in the store as well, then raise the usual
  # error.
  # This method will also be called when trying to assign to a non existing
  # attribute. In this case, we will save it to the store.
  def method_missing(method, args=nil, &_block)
    if method.to_s[-1] == "="
      set method.to_s.chomp('=').to_sym, args
    else
      content = get method
      content ? content : allow_missing? ? nil : super
    end
  end

  # Mirror the method_missing behavior.
  def respond_to_missing?(method, include_private=false)
    if method.to_s[-1] == "="
      true
    else
      allow_missing? or !!get(method.to_sym)
    end
  end

  # Allow hash-style access to any of our stored properties.
  # This will not reload from the disk more than once.
  def [](key)
    get key
  end

  # Allow hash-style assignment to new peoperties
  def []=(key, value)
    set key, value
  end

  # Return a nice string when inspecting or printing. 
  # This will load values from the store if they were not already loaded.
  def inspect
    properties = attributes.sort.map { |var| [var, get(var).to_s].join(":") }.join ', '
    properties = " #{properties}" unless properties.empty?
    "<#{self.class.name}#{properties}>"
  end
  alias_method :to_s, :inspect

  # Return attribute names, so we can print them and their values in 
  # `inspect`.
  def attributes
    @attributes ||= attributes!
  end

  # Return attribute names from the store.
  # TODO: Maybe also merge with instance_variables. Pay attention to @s.
  def attributes!
    result = []
    store.transaction do 
      if store_key
        result = store[store_key] || {}
        result = result.keys
      else
        result = store.roots
      end
    end
    result = result.select { |a| a.is_a? Symbol }
  end

  private

  # We need to have a default `allow_missing?` method, which may be 
  # overridden by calling `allow_missing`.
  def allow_missing?
    false
  end

  # Get a value from the store, and set it as an instance variable so that
  # subsequent calls do not access the disk.
  def get(key)
    result = instance_variable_get("@#{key}")
    result.nil? ? get!(key) : result
  end

  # Hard get value from the store.
  def get!(key)
    result = store.transaction do 
      if store_key
        store[store_key] ||= {}
        store[store_key][key] 
      else
        store[key]
      end
    end
    instance_variable_set "@#{key}", result
  end

  # Set a key=value pair in the store, and in an instance variable so that
  # any subsequent call to `get` will not have to read it from the disk.
  # In addition, add it to the attributes list, which is used by `inspect`.
  def set(key, value)
    instance_variable_set "@#{key}", value
    attributes << key unless attributes.include? key
    store.transaction do
      if store_key
        store[store_key] ||= {}
        store[store_key][key] = value
      else
        store[key] = value
      end
    end 
  end

  # The default store location. May be overridden by the inheriting class.
  def to_store
    "#{self.class.to_s.downcase}.yml"
  end

  # Return the actual store object. It can either be a YAML::Store or a 
  # PStore, which behave exactly the same.
  def store
    @store ||= store!
  end

  # Hard get the actual store object, based on the provided file extension.
  def store!
    if ['.yml', 'yaml'].include?(store_file[-4,4]) 
      YAML::Store.new(store_file) 
    else
      PStore.new(store_file)
    end
  end

  # Return the store filename.
  def store_file
    @store_file ||= store_file! 
  end

  # Hard return the store filename based on the value of `to_store`.
  # If an array, the first element is the path.
  def store_file!
    to_store.is_a?(Array) ? to_store[0] : to_store
  end

  # Return the key to use in case multiple objects are to be saved in the
  # same file.
  def store_key
    @store_key.nil? ? @store_key = store_key! : @store_key
  end

  # Hard return the store key based on the `to_store` value. If an array,
  # the second element represents the key.
  def store_key!
    to_store.is_a?(Array) ? to_store[1] : false
  end

end
