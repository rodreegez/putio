require 'Net/http'

require 'putio/user'

module Putio
  class Client
    include User
    attr_accessor :api_key, :api_secret, :klass, :action

    def initialize(api_key, api_secret)
      @api_key = api_key
      @api_secret = api_secret
    end

    def request
      Net::HTTP.get_response(%Q{http://api.put.io/v1/} +
          %Q{#{@klass}?method=#{@action}} +
          %Q{&request={"api_key":"#{@api_key}","api_secret":"#{@api_secret}","params":{}}})
    end
  end
end
