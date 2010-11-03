require 'test_helper'

class UserTest < Test::Unit::TestCase
  context 'A Putio client with valid credentials' do
    setup { @putio = Putio.new('abc', '123') }
    should 'return user\'s info' do
      stub(%Q|http://api.put.io/v1/user?method=info&request=|, 'user_info.json')
      user_info = @putio.get_user_info

      assert_equal %Q{{"test":"data"}}, user_info.chomp
    end
  end
end
