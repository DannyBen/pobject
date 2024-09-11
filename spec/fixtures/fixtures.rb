# A basic fixture used for testing the most minimal implementation
class Settings < PObject
end

# Test a different YAML location
class Product < PObject
  def to_store
    'spec/tmp/storage.yml'
  end
end

# Test a different, non YAML (pstore) location
class Monster < PObject
  def to_store
    'spec/tmp/monster.pstore'
  end
end

# Test multiple objects in the same store
class Hero < PObject
  def initialize(id)
    @id = id
  end

  def to_store
    ['spec/tmp/heroes.yml', @id]
  end
end

# Test allow_missing
class Book < PObject
  allow_missing
end
