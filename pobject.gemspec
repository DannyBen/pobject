lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'date'
require 'pobject/version'

Gem::Specification.new do |s|
  s.name        = 'pobject'
  s.version     = PObject::VERSION
  s.summary     = 'Persistent Object'
  s.description = 'Auto save objects as files'
  s.authors     = ['Danny Ben Shitrit']
  s.email       = 'db@dannyben.com'
  s.files       = Dir['README.md', 'lib/**/*.*']
  s.homepage    = 'https://github.com/DannyBen/pobject'
  s.license     = 'MIT'
  s.required_ruby_version = '>= 3.0.0'

  s.add_dependency 'pstore', '~> 0.1'

  s.metadata = {
    'bug_tracker_uri'       => 'https://github.com/DannyBen/pobject/issues',
    'source_code_uri'       => 'https://github.com/DannyBen/pobject',
    'rubygems_mfa_required' => 'true',
  }
end
