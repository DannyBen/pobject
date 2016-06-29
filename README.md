Persistent Object
==================================================

[![Gem](https://img.shields.io/gem/v/pobject.svg?style=flat-square)](https://rubygems.org/gems/pobject)
[![Travis](https://img.shields.io/travis/DannyBen/pobject.svg?style=flat-square)](https://travis-ci.org/DannyBen/pobject)
[![Code Climate](https://img.shields.io/codeclimate/github/DannyBen/pobject.svg?style=flat-square)](https://codeclimate.com/github/DannyBen/pobject)
[![Gemnasium](https://img.shields.io/gemnasium/DannyBen/pobject.svg?style=flat-square)](https://gemnasium.com/DannyBen/pobject)

---

Transparently persist objects to disk as YAML or PStore files.

---

Install
--------------------------------------------------

```
$ gem install pobject
```

Or with bundler:

```ruby
gem 'pobject'
```

Usage
--------------------------------------------------

Your object should inherit from PObject.

```ruby
require 'pobject'

class Settings < PObject
end
```

Now, any time you access a property, it is saved to a file. By default, we will 
svae a YAML file with the same name as the class:


```ruby
class Settings < PObject
end

config = Settings.new
config.port = 3000
# Will create a 'settings.yml' file and store the port value
```

You can access any attributes by either dot notation or hash notation.

```
config.port
# => 3000

config[:port]
# => 3000
```

To change the location of the file, simply override the `to_store` method.

```ruby
class Settings < PObject
  def to_store
    "config/local.yml"
  end
end

config = Settings.new
config.port = 3000
# Will create a 'config/local.yml'
```

Whenever you use the `.yml` extension, PObject will store a YAML file. If you
wish to store a `PStore` object instead, provide any other extension:

```ruby
class Settings < PObject
  def to_store
    "config/local.pstore"
  end
end
```

To store several objects in one store file, your `to_store` method should 
return an array with two elements: The first, is the path to the file and 
the second is any unique key identifying the instance.

```ruby
class Hero < PObject
  def initialize(id)
    @id = id
  end

  def to_store
    ["heroes.yml", @id]
  end
end

hammer = Hero.new :hammer
raynor = Hero.new :raynor

hammer.name = 'Sgt. Hammer'
raynor.name = 'Raynor'
# => 
# ---
# :hammer:
#   :name: Sgt. Hammer
# :raynor:
#   :name: Raynor
```

By default, PObject will raise an error when accessing a property that does
not exist. To change this behavior, call `allow_missing` at the beinning of
your object

```ruby
class Book < PObject
  allow_missing
end

book = Book.new
book.author
# => nil
```
