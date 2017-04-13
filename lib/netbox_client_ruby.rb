#require "netbox_client_ruby"
require 'dry-configurable'
require 'netbox_client_ruby/api'

module NetboxClientRuby
  extend Dry::Configurable

  setting :netbox do
    setting :api_base_url
    setting :auth do
      setting :token
    end
    setting :pagination do
      setting :default_limit, 50
    end
  end

  setting :faraday do
    setting :adapter, :net_http
    setting :logger
    setting :request_options, open_timeout: 1, timeout: 5
  end
end
