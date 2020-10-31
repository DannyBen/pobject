Persistent Object
==================================================

[![Gem Version](https://badge.fury.io/rb/pobject.svg)](https://badge.fury.io/rb/pobject)
[![Build Status](https://github.com/DannyBen/pobject/workflows/Test/badge.svg)](https://github.com/DannyBen/pobject/actions?query=workflow%3ATest)
[![Maintainability](https://api.codeclimate.com/v1/badges/aa8fa554a6b71904cd4e/maintainability)](https://codeclimate.com/github/DannyBen/pobject/maintainability)

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

Your object should inherit from `PObject`.

```ruby
require 'pobject'

class Settings < PObject
end
```

Now, any time you access a property, it is saved to a file. By default, we
will save a YAML file with the same name as the class.


```ruby
class Settings < PObject
end

config = Settings.new
config.port = 3000
# Will create a 'settings.yml' file and store the port value
```

You can access any property by either dot notation or hash notation.

```ruby
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

Whenever you use the `.yml` (or `.yaml`) extension, we will store a YAML 
file. If you wish to store a `PStore` object instead, use any other 
extension.

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

puts File.read 'heroes.yml'
# => 
# ---
# :hammer:
#   :name: Sgt. Hammer
# :raynor:
#   :name: Raynor
```

By default, PObject will raise an error when accessing a property that does
not exist. To change this behavior, call `allow_missing` at the beginning of
your class.

```ruby
class Book < PObject
  allow_missing
end

book = Book.new
book.author
# => nil
```
