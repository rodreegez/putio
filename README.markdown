# Put.io V2

This is a Ruby client for the [Put.io REST API](https://api.put.io/v2/docs/#jsonp) with full support for files, transfers, friends and settings. It utilises the new Put.io V2 with OAuth integration so you can build fully featured applications.

### Installation
**This is a fork of [rodreegez/putio](http://github.com/rodreegez/putio) and I'm awaiting the update of the 'putio' gem. Until then it can be installed with 'putio-cli'**

```ruby
gem install putio
```

### Usage

```ruby
require 'putio'
```

```ruby
p = Putio.new(000, 'abcdefghijklmn012345', 'http://localhost/callback') # Create an application at https://put.io/v2/oauth2/register
```

```ruby
p.me # Show my information
```

## Options

```ruby
Putio::Client.putio_methods # Get all methods like .methods

# Generate a OAuth HTTP URL
p.oauth_url

# Once returned with code, complete authorisation
p.oauth_complete(params[:code])

# Or, if you already have a access token - set it and ignore the previous two steps.
p.access_token = ""

## Files

# Show files in a particular folder.
p.files(folder_id = 0)

# Or just show them all, including those from subfolders.
p.all

# Search for a file
p.search(query, page = 0)

# Upload a local file
p.upload(local_file, folder_id = 0)

# Create a folder
p.create_folder(name, folder_id = 0)

# File properties
p.file(file_id)

# Remove a file
p.delete(file_id)

# Rename a file
p.rename(file_id)

# Move a file
p.move(file_id, folder_id = 0)

# Convert a video file on Put.io to MP4
p.convert_to_mp4(file_id)

# Status of MP4 video
p.mp4(file_id)

# Universal download link of a file
p.download(file_id)

# Universal download link of a ZIP of multiple files
p.zip(file_ids) # Example: p.zip([300, 59412, 9313])

## Transfers

# Show all current transfers
p.transfers

# Show count of transfer queue
p.transfers_count

# Create a transfer
# Note: Callback URL pings a HTTP URL when a file/torrent has been downloaded to Put.io
p.create_transfer(http_url, folder_id = 0, extract_if_possible = true, callback_url = nil)

# Show status on transfer
p.transfer(transfer_id)

# Cancel Transfer
p.cancel_transfers(ids) # Example: p.cancel_transfers([412421, 4812984, 19334])

# Clean transfers queue (i.e. remove completed transfers)
p.clean_transfers

# Show authenticated user
p.me

# Show preferences of authenticated user
p.settings

# My Put.io friends
p.friends

# My Put.io incoming friend requests
p.friend_requests

# Deny friend request
p.deny_friend_request(username)

# Send friend request
p.make_friends_with(username)```

## Todo
- Make Putio::Client object syntax 'chain' better (i.e. `Putio::File.new(391239123).delete`)
- Update test units to reflect V2 API.

## Changelog

23/6/2013
- Added support for V2 API
- Added OAuth Support
- Removed development folder.
- Removed :rubygems and replaced with 'http://rubygems.org'