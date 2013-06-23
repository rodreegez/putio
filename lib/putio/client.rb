##
## Let's include our dependencies.
##
require 'curb'
require 'rubygems'
require 'hashie'
require 'json'
require 'uri'
require 'cgi'


##
## Let's extend :String to identify an Integer.
##
class String
    def is_i?
       !!(self =~ /^[-+]?[0-9]+$/)
    end
end


##
## This serves custom errors that people can begin-rescue.
##
module PutioError
  class ClientIDInvalid < Exception; end
  class FileNotExist < Exception; end
end


##
## This contains the entire Putio Ruby interface.
##
module Putio

  # This is used to make reading code easier later. Ignore this.
  class HTTP
    attr_reader :GET, :POST
    GET, POST = false, true
  end

  # Our Ruby client.
  class Client
    # Instance-based variables we'll need to allocate memory for.
    attr_writer :client_id, :application_secret, :redirect_uri, :access_token
    # The base Put.io API URL.
    PUTIO_BASE_URL = "https://api.put.io/v2"


    ##
    ## Putio::Client.new
    ## Initialize the Putio::Client instance.
    ##
    def initialize(client_id, application_secret, redirect_uri, access_token = nil)
      # The client_id must be a Integer
      raise PutioError::ClientIDInvalid unless client_id.to_s.is_i?

      # Store arguments as instance variables
      @client_id = client_id
      @application_secret = application_secret
      @redirect_uri = redirect_uri
      @access_token = access_token || nil
    end


    ##
    ## Putio::Client.putio_methods
    ## Similar to .methods - you can use this to see all possible Put.io-related methods.
    ##
    def putio_methods
      [:oauth_url, :oauth_complete, :files, :all, :search, :upload, :create_folder, :file, :delete, :rename, :move, :convert_to_mp4, :mp4, :download, :zip, :transfers, :transfers_count, :create_transfer, :cancel_transfer, :cancel_transfers, :clean_transfers, :me, :settings, :friends, :friend_requests, :deny_friend_requests, :make_friend_with]
    end


    ##
    ## Putio::Client.oauth_url(response_type)
    ## Provides a OAuth URL on Put.io for the user to grant access.
    ##
    def oauth_url(response_type = 'code')
      # The Redirect URI must be the same as registered with Put.io
      PUTIO_BASE_URL + "/oauth2/authenticate?client_id=%i&response_type=%s&redirect_uri=%s" % [@client_id, response_type, @redirect_uri]
    end


    ##
    ## Putio::Client.oauth_complete(code)
    ## Provides an oauth_token used to authenticate API calls.
    ##
    def oauth_complete(code)
      # Let's compile the API URL we're calling.
      url = PUTIO_BASE_URL + "/oauth2/access_token?client_id=%i&client_secret=%s&grant_type=authorization_code&redirect_uri=%s&code=%s" % [@client_id, @application_secret, @redirect_uri, code]
      
      # And call it.
      response = Curl::Easy.perform(url) do |req|
        req.headers['Accept'] = 'application/json'
      end

      # Use Crack to parse the JSON
      response = Crack::JSON.parse(response.body_str)

      # And use Hashie to present it.
      response = Hashie::Mash.new(response)

      # Save it locally.
      @access_token = response.access_token

      # Return it
      response
    end


    ##
    ## Putio::Client.files(folder)
    ## Shows all the users files in a particular folder.
    ##
    def files(folder = 0)
      # Requires authorization
      raise PutioError::AuthorizationRequired if authentication_required!

      make_get_call('/files/list?parent_id=%i' % [folder]).files
    end


    ##
    ## Putio::Client.all
    ## Shows all the files, including from subfolders.
    ##
    def all
      # Requires authorization
      raise PutioError::AuthorizationRequired if authentication_required!

      files(-1)
    end


    ##
    ## Putio::Client.search(query, page)
    ## Makes a file search against you and your shared files.
    ##
    def search(query, page = 0)
      # Requires authorization
      raise PutioError::AuthorizationRequired if authentication_required!

      make_get_call('/files/list?parent_id=%i' % [folder]).files
    end


    ##
    ## Putio::Client.upload(file, folder)
    ## Upload a local file to Put.io
    ##
    def upload(file, folder = 0)
      # Requires authorization
      raise PutioError::AuthorizationRequired if authentication_required!

      # Make the upload.
      response = make_upload_call('/files/upload?parent_id=%i' % [folder], file)

      # Return whatever.
      response.transfer || response.file
    end


    ##
    ## Putio::Client.create_folder(name, folder)
    ## Creates a new folder in your Put.io space.
    ##
    def create_folder(name, folder = 0)
      # Requires authorization
      raise PutioError::AuthorizationRequired if authentication_required!

      make_post_call('/files/create-folder?name=%s&parent_id=%i' % [name, folder])
    end


    ##
    ## Putio::Client.file(id)
    ## Returns the properties of a particular file.
    ##
    def file(id)
      # Requires authorization
      raise PutioError::AuthorizationRequired if authentication_required!

      response = make_get_call('/files/%i' % [id])
      response.download = download(id)

      response
    end


    ##
    ## Putio::Client.delete(id)
    ## Removes a particular file. Parameter can be Integer or Array
    ##
    def delete(id)
      # Requires authorization
      raise PutioError::AuthorizationRequired if authentication_required!

      if id.is_a? Array then
        id = id.join(',')
      end

      make_post_call('/files/delete?file_ids=%s' % [id]).status == "OK"
    end

    ##
    ## Putio::Client.rename(id, name)
    ## Renames a particular file.
    ##
    def rename(id, name)
      # Requires authorization
      raise PutioError::AuthorizationRequired if authentication_required!

      make_post_call('/files/rename?file_id=%i&name=%s' % [id, name]).status == "OK"
    end

    ##
    ## Putio::Client.move(id, folder)
    ## Move a file to another directory.
    ##
    def move(id, folder = 0)
      # Requires authorization
      raise PutioError::AuthorizationRequired if authentication_required!

      # This provides support for an Array of ids.
      if id.is_a? Array then
        id = id.join(',')
      end

      make_post_call('/files/move?file_ids=%s&parent_id=%i' % [id, folder]).status == "OK"
    end


    ##
    ## Putio::Client.convert_to_mp4(id)
    ## Put.io offer MP4 conversion - call this method to convert a video.
    ##
    def convert_to_mp4(id)
      # Requires authorization
      raise PutioError::AuthorizationRequired if authentication_required!

      make_post_call('/files/%i/mp4' % [id]).status == "OK"
    end


    ##
    ## Putio::Client.mp4(id)
    ## Put.io offer MP4 conversion - call this method to see the status of the MP4 video.
    ##
    def mp4(id)
      # Requires authorization
      raise PutioError::AuthorizationRequired if authentication_required!

      make_get_call('/files/%i/mp4' % [id]).mp4
    end


    ##
    ## Putio::Client.download(id)
    ## Provides a URL for anyone to download a file.
    ##
    def download(id)
      # Requires authorization
      raise PutioError::AuthorizationRequired if authentication_required!

      PUTIO_BASE_URL + ("/files/%i/download?oauth_token=%s" % [id, @access_token])
    end


    ##
    ## Putio::Client.zip(id)
    ## Provides a URL of a ZIP of multiple files.
    ##
    def zip(id)
      # Requires authorization
      raise PutioError::AuthorizationRequired if authentication_required!

      # This provides support for an Array of ids.
      if id.is_a? Array then
        id = id.join(',')
      end

      # Return zip download link
      PUTIO_BASE_URL + ("/files/zip?file_ids=%s&oauth_token=%s" % [id, @access_token])
    end


    ##
    ## Putio::Client.transfers
    ## Shows all the current transfers.
    ##
    def transfers
      # Requires authorization
      raise PutioError::AuthorizationRequired if authentication_required!

      make_get_call('/transfers/list').transfers
    end


    ##
    ## Putio::Client.transfers_count
    ## Shows how many downloads are currently in the queue.
    ##
    def transfers_count
      # Requires authorization
      raise PutioError::AuthorizationRequired if authentication_required!

      make_get_call('/transfers/count').count
    end


    ##
    ## Putio::Client.create_transfer(url, folder, extract, callback_url)
    ## Download an external file/torrent. Optionally choose to extract and have a HTTP callback URL on download completion.
    ##
    def create_transfer(url, folder = 0, extract = true, callback_url = nil)
      # Requires authorization
      raise PutioError::AuthorizationRequired if authentication_required!

      make_post_call('/transfers/add?url=%s&save_parent_id=%i&extract=%s&callback_url=%s' % [url, folder, extract.to_s.capitalize, callback_url])
    end


    ##
    ## Putio::Client.transfer(id)
    ## Shows the status of a particular transfer.
    ##
    def transfer(id)
      # Requires authorization
      raise PutioError::AuthorizationRequired if authentication_required!

      make_get_call('/transfers/%i' % [id])
    end


    ##
    ## Putio::Client.cancel_transfer(id)
    ## Alias of Putio::Client.cancel_transfers
    ##
    def cancel_transfer(id)
      cancel_transfers(id)
    end


    ##
    ## Putio::Client.cancel_transfers(id)
    ## Cancels any transfers that have not yet completed. Use delete to remove downloaded files.
    ##
    def cancel_transfers(id)
      # Requires authorization
      raise PutioError::AuthorizationRequired if authentication_required!

      # This provides support for an Array of ids.
      if id.is_a? Array then
        id = id.join(',')
      end

      make_get_call('/transfers/cancel?transfer_ids=%s' % [id]).status == "OK"
    end


    ##
    ## Putio::Client.clean_transfers(id)
    ## Removes any completed transfers from the list.
    ##
    def clean_transfers(id)
      # Requires authorization
      raise PutioError::AuthorizationRequired if authentication_required!

      make_get_call('/transfers/clean').status == "OK"
    end


    ##
    ## Putio::Client.me
    ## Shows information about the authenticated user.
    ##
    def me
      # Requires authorization
      raise PutioError::AuthorizationRequired if authentication_required!

      make_get_call('/account/info').info
    end


    ##
    ## Putio::Client.settings
    ## Shows preferences of the authenticated user.
    ##
    def settings
      # Requires authorization
      raise PutioError::AuthorizationRequired if authentication_required!

      make_get_call('/account/settings').settings
    end


    ##
    ## Putio::Client.friends
    ## Shows all the friends of the authenticated user.
    ##
    def friends
      # Requires authorization
      raise PutioError::AuthorizationRequired if authentication_required!

      make_get_call('/friends/list').friends
    end


    ##
    ## Putio::Client.friend_requests
    ## Shows pending friend requests of the authenticated user.
    ##
    def friend_requests
      # Requires authorization
      raise PutioError::AuthorizationRequired if authentication_required!

      make_get_call('/friends/waiting-requests').friends
    end


    ##
    ## Putio::Client.deny_friend_requests(username)
    ## Rejects a friend request.
    ##
    def deny_friend_request(username)
      # Requires authorization
      raise PutioError::AuthorizationRequired if authentication_required!

      make_post_call('/friends/%s/deny' % [username]).status == "OK"
    end


    ##
    ## Putio::Client.make_friend_with(username)
    ## This sends a friend request to a particular user.
    ##
    def make_friend_with(username)
      # Requires authorization
      raise PutioError::AuthorizationRequired if authentication_required!

      make_post_call('/friends/%s/request' % [username]).status == "OK"
    end


    private

    ##
    ## Putio::Client.authentication_required!
    ## A private function used to tell if the user has granted access.
    ##
    def authentication_required!
      @access_token.nil?
    end

    ##
    ## Putio::Client.make_call(endpoint)
    ## This is the underlying code that makes the HTTP request.
    ##
    def make_call(endpoint, is_post = false)
      # Before anything.. is it a POST request?
      postdata = Hash.new

      # It's a HTTP POST request.
      if is_post && endpoint.include?('?') then
        endpoint, postdata = endpoint.split('?')
        postdata = CGI::parse(postdata)
      end

      # Let's compile the API URL we're calling.
      url = PUTIO_BASE_URL + endpoint
      url += url.include?("?") ? "&" : "?"
      url += "oauth_token=%s" % [@access_token]

      # And call it. POST or GET ;)
      if is_post then
        response = Curl.post(url, postdata) { |req| req.headers['Accept'] = 'application/json' }
      else
        response = Curl.get(url) { |req| req.headers['Accept'] = 'application/json' }
      end

      # Natively parse the JSON
      response = JSON::parse(response.body_str)

      # And use Hashie to present it.
      response = Hashie::Mash.new(response)
    end

    ##
    ## Putio::Client.make_get_call(endpoint)
    ## This is the underlying code that makes the HTTP GET request.
    ##
    def make_get_call(endpoint)
      make_call(endpoint, Putio::HTTP::GET)
    end

    ##
    ## Putio::Client.make_post_call(endpoint)
    ## This is the underlying code that makes the HTTP POST request.
    ##
    def make_post_call(endpoint)
      make_call(endpoint, Putio::HTTP::POST)
    end

    ##
    ## Putio::Client.make_upload_call(endpoint, file)
    ## This is the underlying code that makes the HTTP multipart POST request.
    ##
    def make_upload_call(endpoint, file)
      raise PutioError::FileNotExist unless File.exists?(file)

      # Let's compile the API URL we're calling.
      url = PUTIO_BASE_URL + endpoint
      url += url.include?("?") ? "&" : "?"
      url += "oauth_token=%s" % [@access_token]

      # And call it.
      response = Curl::Easy.new(url)
      response.multipart_form_post = true
      response.headers['Accept'] = 'application/json'
      response.http_post(Curl::PostField.file('file', file))

      # Natively parse the JSON
      response = JSON::parse(response.body_str)
      
      # And use Hashie to present it.
      response = Hashie::Mash.new(response)
    end

  end
end
