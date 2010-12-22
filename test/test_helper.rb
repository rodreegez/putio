require 'test/unit'
require 'rubygems'
require 'bundler/setup'
Bundler.require

require 'lib/putio'

FakeWeb.allow_net_connect = false

def fixture_file(filename)
  return '' if filename == ''
  file_path = File.expand_path(File.dirname(__FILE__) + '/fixtures/' + filename)
  File.read(file_path)
end

def stub(http, path, file)
  response = { :body => fixture_file(file), :content_type => 'text/json' }
  FakeWeb.register_uri(http, path, response)
end
