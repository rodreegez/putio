A ruby interface to [the Put.io API](https://www.put.io/service/api).

## About ##

The Put.io api is quite complex. This gem allows you to call methods in
the form of:

    <request type (get or post)_<class (users, files etc)>_<method(list, info etc)>

e.g.

    get_user_info

This will return a hash of [mashies](https://github.com/intridea/hashie) that can
be queried like a regular object.

## Usage ##

    # require the gem
    require 'putio'

    # create an instance of a client
    p = Putio.new('abc', '123')
    => #<Putio::Client:0x1006f2c40 @api_secret="123", @api_key="abc">

    # make a request
    info = p.get_user_info
    => [<#Hashie::Mash dir_id="7731413" id="8664" name="Adam Rogers">]

    # query the hash
    info.first.name
    => "Adam Rogers"
