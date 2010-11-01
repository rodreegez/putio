require "net/http"
require "uri"
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
      http = Net::HTTP.new("api.put.io")
      request = Net::HTTP::Put.new(%Q{/v1/#{@klass}?method=#{@action}&request=})
      request.set_form_data(%Q{{"api_key":"#{@api_key}","api_secret":"#{@api_secret}","params":{}}})
      response = http.request(request)
      response.body
    end
  end
end
