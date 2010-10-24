require 'test_helper'

class PutioTest < Test::Unit::TestCase
  context 'Putio' do
    should 'initilize a Client with api_key and api_secret' do
      putio = Putio.new('api_key', 'api_secret')

      assert_instance_of Putio::Client, putio
    end
  end
end
