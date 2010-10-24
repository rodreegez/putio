module Putio
  def self.new(api_key, api_secret)
    Putio::Client.new(api_key, api_secret)
  end
end
