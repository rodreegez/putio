require 'test_helper'

class ClientTest < Test::Unit::TestCase
  context 'creating a new client' do
    should 'succeed with api_key and api_secret' do
      assert_nothing_raised do
        putio = Putio::Client.new('api_key', 'api_secret')
      end
    end
  end
end
