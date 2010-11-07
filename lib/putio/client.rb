require 'net/http'
require 'rubygems'
require 'crack/json'
require 'hashie'
require 'json'
require 'uri'
require 'cgi'

module Putio
  class Client
    attr_accessor :api_key, :api_secret, :klass, :action

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
        request = Net::HTTP::Post.new(BaseUrl.path + request_url)
        request.set_form_data(request_params)
        response = Net::HTTP.new(BaseUrl.host, BaseUrl.port).start {|http| 
          http.request(request) 
        }
      else
        # TODO: Raise Putio::Error or something
        "you're shit out of luck, son"
      end
    end

    def parse_response(response)
      parsed = Crack::JSON.parse(response)
      mashed_response = Hashie::Mash.new(parsed)
      mashed_response.response.results
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
