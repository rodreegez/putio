require 'test_helper'

class UserTest < Test::Unit::TestCase
  context 'A Putio client with valid credentials' do
    setup { @putio = Putio.new('abc', '123') }

    should 'return user\'s info via GET' do
      stub_get(%r(http://api.put.io/v1/user*), 'user_info.json')
      user_info = @putio.get_user_info

      assert_equal "rodreegez", user_info.name
    end

    should 'return user\'s info via POST' do
      stub_post(%r(http://api.put.io/v1/*), 'user_info.json')
      user_info = @putio.post_user_info

      assert_equal "rodreegez", user_info.name
    end

    should 'return user\'s friends via GET' do
      stub_get(%r(http://api.put.io/v1/user*), 'user_friends.json')
      user_friends = @putio.get_user_friends

      assert_equal "Dean Strelau", user_friends.first.name
    end
  end
end
