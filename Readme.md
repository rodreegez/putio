A ruby interface to the API at http://api.put.io.

## Usage ##

    require 'putio'

    p = Putio.new('abc', '123')
    => #<Putio::Client:0x1006f2c40 @api_secret="123", @api_key="abc">

    p.get_user_info
    =>

    p.get_file_list
    =>

    ...
