# frozen_string_literal: true

module NetboxClientRuby
  module Secrets
    class RSAKeyPair
      include Communication

      PATH = '/api/secrets/generate-rsa-key-pair/'.freeze

      def public_key
        get['public_key']
      end

      def private_key
        get['private_key']
      end

      def reload
        @response = nil
      end

      private

      def get
        if authorization_token
          @response ||= response connection.get(PATH)
        else
          raise LocalError,
                "The authorization_token has not been configured, but it's required for get-session-key."
        end
      end

      def authorization_token
        auth_config.token
      end

      def auth_config
        netbox_config.auth
      end

      def netbox_config
        NetboxClientRuby.config.netbox
      end
    end
  end
end
