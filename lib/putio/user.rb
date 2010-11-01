module User
  @klass  = 'user'

  def get_user_info
    @action = 'info'
    request
  end
end
