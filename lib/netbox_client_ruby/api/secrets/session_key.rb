# frozen_string_literal: true

module NetboxClientRuby
  module Secrets
    class SessionKey
      include Communication

      PATH = '/api/secrets/get-session-key/'.freeze

      def initialize
        session_key
      end

      def session_key
        NetboxClientRuby::Secrets.session_key ||= request['session_key']
      end

      def reload
        NetboxClientRuby::Secrets.session_key = request['session_key']
      end

      private

      def request
        if authorization_token
          response(post)
        else
          raise LocalError,
                "The authorization_token has not been configured, but it's required for get-session-key."
        end
      end

      def post
        connection.post PATH, private_key: private_key
      end

      def connection
        NetboxClientRuby::Connection.new(request_encoding: :url_encoded)
      end

      def authorization_token
        auth_config.token
      end

      def private_key
        key_file = open_private_key_file
        encoded_private_key = read_private_key_file(key_file)
        private_key = decode_private_key(encoded_private_key)
        private_key.to_pem
      end

      def decode_private_key(encoded_private_key)
        begin
          private_key = OpenSSL::PKey::RSA.new encoded_private_key, rsa_private_key_password

          return private_key if private_key.private?
        rescue OpenSSL::PKey::RSAError
          if rsa_private_key_password.empty?
            raise LocalError,
                  "The private key at '#{rsa_private_key_path}' requires a password, but none was given, or the key data is corrupted. (The corresponding configuration is 'netbox.auth.rsa_private_key.password'.)"
          else
            raise LocalError,
                  "The password given for the private key at '#{rsa_private_key_path}' is not valid or the key data is corrupted. (The corresponding configuration is 'netbox.auth.rsa_private_key.password'.)"
          end
        end

        raise LocalError,
              "The file at '#{rsa_private_key_path}' is not a private key, but a private key is required for get-session-key. (The corresponding configuration is 'netbox.auth.rsa_private_key.path'.)"
      end

      def rsa_private_key_password
        pwd = rsa_private_key_config.password
        # If nil is not converted to '', then OpenSSL will block and ask on console for the password.
        # We really don't want that.
        return '' if pwd.nil?
        pwd
      end

      def read_private_key_file(key_file)
        encoded_private_key = key_file.read
        return encoded_private_key unless encoded_private_key.nil? || encoded_private_key.empty?

        raise LocalError,
              "The file at '#{rsa_private_key_path}' is empty, but a private key is required for get-session-key. (The corresponding configuration is 'netbox.auth.rsa_private_key.path'.)"
      end

      def open_private_key_file
        return File.new rsa_private_key_path if File.exist? rsa_private_key_path

        raise LocalError,
              "No file exists at the given path '#{rsa_private_key_path}', but it's required for get-session-key. (The corresponding configuration is 'netbox.auth.rsa_private_key.path'.)"
      end

      def rsa_private_key_path
        @rsa_private_key_path ||= File.expand_path(rsa_private_key_config.path)
      end

      def rsa_private_key_config
        auth_config.rsa_private_key
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
