require 'test/unit'
require 'rubygems'
require 'shoulda'
require 'fakeweb'

require 'lib/putio'

FakeWeb.allow_net_connect = false

def fixture_file(filename)
  return '' if filename == ''
  file_path = File.expand_path(File.dirname(__FILE__) + '/fixtures/' + filename)
  File.read(file_path)
end

def stub_get(path, file)
  response = { :body => fixture_file(file), :content_type => 'text/json' }
  FakeWeb.register_uri(:get, path, response)
end

def stub_post(path, file)
  response = { :body => fixture_file(file), :content_type => 'text/json' }
  FakeWeb.register_uri(:post, path, response)
end
