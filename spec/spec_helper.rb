require 'simplecov'
SimpleCov.start

require 'rubygems'
require 'bundler'
Bundler.require :default, :development

require 'fileutils'
require_relative 'fixtures/fixtures'

def reset_tmp
  FileUtils.rm Dir['spec/tmp/*.{yml,pstore}']
end