# NetboxClientRuby

[![Build Status](https://travis-ci.org/ninech/netbox-client-ruby.svg?branch=master)](https://travis-ci.org/ninech/netbox-client-ruby)
[![Gem Version](https://badge.fury.io/rb/netbox-client-ruby.svg)](https://badge.fury.io/rb/netbox-client-ruby)
[![Code Climate](https://codeclimate.com/github/ninech/netbox-client-ruby/badges/gpa.svg)](https://codeclimate.com/github/ninech/netbox-client-ruby)

This is a gem to pragmatically access your [Netbox instance](https://github.com/digitalocean/netbox)
via it's API from Ruby. This gem is currently only compatible with Netbox v2.4 or newer.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'netbox-client-ruby'
```

And then execute:

    $ bundle

Or install it manually:

    $ gem install netbox-client-ruby

## Usage

### Configuration

Put this somewhere, where it runs, before any call to anything else of Netbox.
If you are using Rails, then this would probably be somewhere underneath /config.

```ruby
require 'netbox-client-ruby'
NetboxClientRuby.configure do |config|
  config.netbox.auth.token = 'YOUR_API_TOKEN'
  config.netbox.api_base_url = 'http://netbox.local/api/'

  # these are optional:
  config.netbox.auth.rsa_private_key.path = '~/.ssh/netbox_rsa'
  config.netbox.auth.rsa_private_key.password = ''
  config.netbox.pagination.default_limit = 50
  config.faraday.adapter = Faraday.default_adapter
  config.faraday.request_options = { open_timeout: 1, timeout: 5 }
  config.faraday.logger = :logger # built-in options: :logger, :detailed_logger; default: nil
end
```

### Structure

The methods are aligned with the API as it is defined in Netbox.
You can explore the API endpoints in your browser by opening the API endpoint. Usually that's `http://YOUR_NETBOX/api/`.

So if the URL is `/api/dcim/sites.json`, then the corresponding Ruby code would be `NetboxClientRuby.dcim.sites`.

### Examples

```ruby
# configuration
NetboxClientRuby.configure do |c|
  c.netbox.auth.token = '2e35594ec8710e9922d14365a1ea66f27ea69450'
  c.netbox.api_base_url = 'http://netbox.local/api/'
  c.netbox.auth.rsa_private_key.path = '~/.ssh/netbox_rsa'
end

# get all sites
sites = NetboxClientRuby.dcim.sites
puts "There are #{sites.total} sites in your Netbox instance."

# get the first site of the result set
first_site = sites.first
puts "The first site is called #{first_site.name}."

# filter devices by site
# Note that Netbox filters by *slug*
devices_of_site = NetboxClientRuby.dcim.devices.filter(site: first_site.slug)
puts "#{devices_of_site.total} devices belong to the site. #{devices_of_site}.length devices have been fetched."

# Finds a specific device
NetboxClientRuby.dcim.devices.find_by(name: 'my-device', other_field: 'other-value')

# Finds a specific device with a certain custom field
NetboxClientRuby.dcim.devices.find_by(cf_custom_url: 'https://google.com')

# Or a mix of regular and custom fields
NetboxClientRuby.dcim.devices.find_by(name: 'my-device', cf_custom_field: 'custom-value')

# get a site by id
s = NetboxClientRuby.dcim.site(1)

# update a site
s.update(name: 'Zurich', slug: 'zrh')

# update a site (alternative)
s.name = 'Amsterdam'
s.slug = 'ams'
s.save

# create a site
new_s = NetboxClientRuby::DCIM::Site.new
new_s.name = 'Berlin'
new_s.slug = 'ber'
new_s.save

# create a site (alternative)
new_s = NetboxClientRuby::DCIM::Site
          .new(name: 'Berlin', slug: 'ber')
          .save

# delete a site
s = NetboxClientRuby.dcim.site(1)
s.delete

# working with secrets
secrets = NetboxClientRuby.secrets.secrets
puts "#{secrets.total} secrets are in your Netbox."
secrets[0].plaintext # => nil, because you have not yet defined a session_key
NetboxClientRuby.secrets.get_session_key # now get a session_key
secrets = NetboxClientRuby.secrets.secrets # you must reload the data from the server
secrets[0].plaintext # => 'super secret password'

# optionally, you can persist the session_key:
session_key = NetboxClientRuby.secrets.get_session_key.session_key
FILE_NAME = File.expand_path('~/.netbox_session_key').freeze
File.write(FILE_NAME, session_key)

# later on, you can restore the persisted session_key:
persisted_session_key = File.read(FILE_NAME)
NetboxClientRuby.secrets.session_key = persisted_session_key
```

## Available Objects

Not all objects which the Netbox API exposes are currently implemented. Implementing new objects
[is trivial](https://github.com/ninech/netbox-client-ruby/commit/e3cee19d21a8a6ce480d7c03d23d7c3fbc92417a), though.

* Circuits:
  * Circuits
  * Circuit Types
  * Circuit Terminations
  * Providers
* DCIM:
  * Console Ports
  * Console Server Ports
  * Devices
  * Device Roles
  * Device Types
  * Interfaces
  * Manufacturers
  * Platforms
  * Power Outlets
  * Power Ports
  * Racks
  * Rack Groups
  * Rack Roles
  * Rack Reservations
  * Regions
  * Sites
* IPAM:
  * Aggregates
  * IP Addresses
  * Prefixes
  * RIRs
  * Roles
  * VLANs
  * VLAN Groups
  * VRFs
* Secrets:
  * Secrets
  * Secret Roles
  * get-session-key
  * generate-rsa-key-pair
* Tenancy:
  * Tenant
  * Tenant Groups
* Virtualization:
  * Cluster Types
  * Cluster Groups
  * Clusters
  * Virtual Machines
  * Interfaces

If you can't find the object you need, also check
[the source code](https://github.com/ninech/netbox-client-ruby/tree/master/lib/netbox_client_ruby/api)
if it was added in the meantime without the list above having been updated.

## Development

After checking out the repo, run `bin/setup` to install dependencies.
Then, run `rake spec` to run the tests.

To install this gem onto your local machine, run `bundle exec rake install`.

To experiment interactively, fire up the Netbox Docker container by running `docker-compose up -d`.
Then, run `bin/console` for an interactive prompt that will allow you to experiment against your local Netbox.

### Load Development Data

To simplify development, e.g. via the `bin/console` described above, there is a very complete sample set of Netbox data readily available.
You can use it to query almost every object and relation in Netbox.

```bash
cat dump.sql | docker-compose exec postgres psql -U postgres
```

### Dump Development from Database

Should you want to export the current set of data, use the command below.

```bash
docker-compose exec postgres pg_dump -U netbox --exclude-table-data=extras_objectchange -Cc netbox > dump.sql
```

(Remove `--exclude-table-data=extras_objectchange` from the command if you want to retain the history!)

## Contributing

Bug reports and pull requests are very welcome [on GitHub](https://github.com/ninech/netbox-client-ruby).

Before opening a PR, please

* extend the existing specs
* run rspec
* run rubocop and fix your warnings
* check if this README.md file needs adjustments

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## About

This gem is currently maintained and funded by [nine](https://nine.ch).

[![logo of the company 'nine'](https://logo.apps.at-nine.ch/Dmqied_eSaoBMQwk3vVgn4UIgDo=/trim/500x0/logo_claim.png)](https://www.nine.ch)
