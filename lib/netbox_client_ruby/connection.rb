require 'faraday'
require 'faraday_middleware'
require 'faraday/detailed_logger'
require 'netbox_client_ruby/error/local_error'

module NetboxClientRuby
  class Connection
    def self.new
      config = NetboxClientRuby.config

      new_faraday_from config
    end

    def self.headers
      headers = {}
      netbox_auth_config = NetboxClientRuby.config.netbox.auth
      if !netbox_auth_config.token.nil?
        headers['Authorization'] = "Token #{netbox_auth_config.token}"
      else
        fail LocalError, 'The authorization_token has not been configured.'
      end
      headers
    end

    private_class_method def self.new_faraday_from(config)
                           Faraday.new(url: config.netbox.api_base_url, headers: headers) do |faraday|
                             faraday.request :json
                             faraday.response config.faraday.logger if config.faraday.logger
                             faraday.response :json, content_type: /\bjson$/

                             faraday.adapter config.faraday.adapter || Faraday.default_adapter
                           end
                         end
  end
end
