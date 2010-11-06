require 'test_helper'

class UserTest < Test::Unit::TestCase
  context 'A Putio client with valid credentials' do
    setup { @putio = Putio.new('abc', '123') }
    should 'return user\'s info' do
      stub(%r(http://api.put.io/v1/user*), 'user_info.json')
      user_info = @putio.get_user_info

      assert_equal "rodreegez", user_info.name
    end
  end
end
