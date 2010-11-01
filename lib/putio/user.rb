module User
  def get_user_info
    @klass  = 'user'
    @action = 'info'
    request
  end
end
