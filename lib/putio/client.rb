require 'net/http'
require 'rubygems'
require 'crack/json'
require 'hashie'
require 'json'
require 'uri'
require 'cgi'
require 'putio/user'

module Putio
  class Client
    include User

    attr_writer :api_key, :api_secret, :klass, :action
    attr_reader :response

    BaseUrl = URI.parse('http://api.put.io/v1')

    def initialize(api_key, api_secret)
      @api_key = api_key
      @api_secret = api_secret
    end

    # rather than define everything, method_missing splits
    # the method name. expects: 
    #
    #     <http request type>_<class>_<action>
    #
    # follwed by any args.
    def method_missing(name, args={})
      arguments = name.to_s.split('_')
      @http_type = arguments.first
      @klass = arguments[1]
      @action = arguments.last
      @params = args
      make_request
    end

    private
    def make_request
      if @http_type == 'get'
        first_bit = 'http://api.put.io/v1/' + request_url
        whole_thing = first_bit + request_params
        url = URI.parse(whole_thing)
        response = Net::HTTP.get_response(url)
        parse_response(response.body)
      elsif @http_type == 'post'
        url = URI.parse("http://api.put.io/v1/" + request_url)
        http = Net::HTTP.new(url.host, url.port)
        request = Net::HTTP::Post.new(url.request_uri)
        request.set_form_data(request_params)
        response = http.request(request)
        parse_response(response.body)
      else
        # TODO: Raise Putio::Error or something
        "you're shit out of luck, son"
      end
    end

    def parse_response(response)
      response.inspect
      parsed = Crack::JSON.parse(response)
      mashed_response = Hashie::Mash.new(parsed)
      @response = mashed_response.response.results
    end

    def request_url
      %Q{#{@klass}?method=#{@action}&request=}
    end

    def request_params
      params_to_json = {:api_key => @api_key, :api_secret => @api_secret, :params => @params}.to_json
      escaped_params = CGI::escape(params_to_json)
    end
  end
end
