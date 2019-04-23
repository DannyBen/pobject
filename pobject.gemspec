lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'date'
require 'pobject/version'

Gem::Specification.new do |s|
  s.name        = 'pobject'
  s.version     = PObject::VERSION
  s.date        = Date.today.to_s
  s.summary     = "Persistent Object"
  s.description = "Auto save objects as files"
  s.authors     = ["Danny Ben Shitrit"]
  s.email       = 'db@dannyben.com'
  s.files       = Dir['README.md', 'lib/**/*.*']
  s.homepage    = 'https://github.com/DannyBen/pobject'
  s.license     = 'MIT'
  s.required_ruby_version = ">= 2.3.0"
end
