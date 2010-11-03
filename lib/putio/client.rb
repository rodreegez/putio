require "net/http"
require "uri"
require "cgi"
require 'putio/user'

module Putio
  class Client
    include User
    attr_accessor :api_key, :api_secret, :klass, :action

    def initialize(api_key, api_secret)
      @api_key = api_key
      @api_secret = api_secret
    end

    def method_missing(name, *args)
      arguments = name.split('_')
      @http = arguments.first
      @klass = arguments[1]
      @method = arguments.last
      @params = *args
      request
    end

    def request
      http = Net::HTTP.new("api.put.io")
      escaped_path = URI.escape(
      %Q{/v1/#{@klass}?method=#{@action}&request={"api_key":"#{@api_key}","api_secret":"#{@api_secret}","params":{}}}
      )
      request = Net::HTTP::Get.new(escaped_path)
      response = http.request(request)
      response.body
    end
  end
end
