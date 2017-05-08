require 'faraday'
require 'faraday_middleware'
require 'faraday/detailed_logger'
require 'netbox_client_ruby/error/local_error'

module NetboxClientRuby
  class Connection
    def self.new
      build_faraday
    end

    def self.headers
      headers = {}
      netbox_auth_config = NetboxClientRuby.config.netbox.auth

      raise LocalError, 'The authorization_token has not been configured.' unless netbox_auth_config.token

      headers['Authorization'] = "Token #{netbox_auth_config.token}"
      headers
    end

    private_class_method def self.build_faraday
      config = NetboxClientRuby.config
      Faraday.new(url: config.netbox.api_base_url, headers: headers) do |faraday|
        faraday.request :json
        faraday.response config.faraday.logger if config.faraday.logger
        faraday.response :json, content_type: /\bjson$/
        faraday.adapter config.faraday.adapter || Faraday.default_adapter
        faraday.options.merge NetboxClientRuby.config.faraday.request_options
      end
    end
  end
end
