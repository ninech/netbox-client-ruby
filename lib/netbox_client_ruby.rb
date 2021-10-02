require 'dry-configurable'
require 'netbox_client_ruby/api'

module NetboxClientRuby
  extend Dry::Configurable

  MAX_SIGNED_64BIT_INT = 9_223_372_036_854_775_807

  setting :netbox do
    setting :api_base_url
    setting :auth do
      setting :token
      setting :rsa_private_key do
        # the default is intentionally not `~/.ssh/id_rsa`,
        # to not accidentally leak someone's main rsa private key
        setting :path, default: '~/.ssh/netbox_rsa'
        setting :password
      end
    end
    setting :pagination do
      setting :default_limit, default: 50
      setting :max_limit, default: MAX_SIGNED_64BIT_INT
    end
  end

  setting :faraday do
    setting :adapter, default: :net_http
    setting :logger
    setting :request_options, default: { open_timeout: 1, timeout: 5 }
  end
end
