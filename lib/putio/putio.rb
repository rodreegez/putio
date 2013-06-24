module Putio
  def self.new(application_id, application_secret, redirect_uri, access_token = nil)
  	# Acts as an alias for Putio::Client.new
    Putio::Client.new(application_id, application_secret, redirect_uri, access_token)
  end
end