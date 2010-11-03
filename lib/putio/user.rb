module User

  def get_user_info
    @klass  = 'user'
    @action = 'info'
    request
  end

  def get_user_friends
    @klass  = 'user'
    @action = 'friends'
    request
  end
end