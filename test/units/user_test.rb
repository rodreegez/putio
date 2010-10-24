require 'test_helper'

class UserTest < Test::Unit::TestCase
  context 'A Putio client with valid credentials' do
    setup { @putio = Putio.new('123456', 'abcdef') }
    should 'return user\'s info' do
      user_info = @putio.get_user_info
      
      assert user_info.is_a? Array
    end
  end
end
