require 'simplecov'
SimpleCov.start

require 'rubygems'
require 'bundler'
Bundler.require :default, :development

require 'fileutils'
require_relative 'fixtures/fixtures'

def reset_tmp
  Dir.mkdir tmp_dir unless Dir.exist? tmp_dir
  FileUtils.rm Dir["#{tmp_dir}/*.{yml,pstore}"]
end

def tmp_dir
  'spec/tmp'
end
