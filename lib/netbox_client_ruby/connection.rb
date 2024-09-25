# frozen_string_literal: true

require 'faraday'
require 'faraday/detailed_logger'
require 'netbox_client_ruby/error'

if Faraday::VERSION < '2'
  begin
    require 'faraday_middleware'
  rescue LoadError => e
    message = <<~MSG
      For the current version of Faraday (#{Faraday::VERSION}), "faraday_middleware"
      is a required peer dependency of "netbox-client-ruby". Please install
      "faraday_middleware" separately OR upgrade to Faraday 2, in which case,
      "faraday_middleware" is not needed to work with "netbox-client-ruby".

      #{e.message}
    MSG
    raise NetboxClientRuby::Error, message
  end
end

module NetboxClientRuby
  class Connection
    DEFAULT_OPTIONS = {
      request_encoding: :json,
    }.freeze

    def self.new(options = {})
      build_faraday(**DEFAULT_OPTIONS.merge(options))
    end

    def self.headers
      headers = {}
      auth_token = auth_config.token
      headers['Authorization'] = "Token #{auth_token}" if auth_token
      headers['X-Session-Key'] = NetboxClientRuby::Secrets.session_key if NetboxClientRuby::Secrets.session_key
      headers
    end

    def self.auth_config
      netbox_config.auth
    end

    def self.netbox_config
      NetboxClientRuby.config.netbox
    end

    private_class_method def self.build_faraday(request_encoding: :json) # rubocop:disable Metrics/AbcSize
      config = NetboxClientRuby.config
      Faraday.new(url: config.netbox.api_base_url, headers: headers) do |faraday|
        faraday.request request_encoding
        faraday.response config.faraday.logger if config.faraday.logger
        faraday.response :json, content_type: /\bjson$/
        faraday.options.merge NetboxClientRuby.config.faraday.request_options
        faraday.options.params_encoder = Faraday::FlatParamsEncoder
        faraday.adapter config.faraday.adapter || Faraday.default_adapter
      end
    end
  end
end
