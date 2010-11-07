module User
  def get_user_info
    @http_type = 'get'
    @klass = 'user'
    @action = 'info'
    @params = {}
    make_request
    @response.first
  end

  def post_user_info
    @http_type = 'get'
    @klass = 'user'
    @action = 'info'
    @params = {}
    make_request
    @response.first
  end
end
