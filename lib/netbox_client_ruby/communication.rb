require 'netbox_client_ruby/error/client_error'
require 'netbox_client_ruby/error/remote_error'
require 'netbox_client_ruby/connection'

module NetboxClientRuby
  module Communication
    def response(response)
      return nil if response.status == 304

      raise_on_http_error response.status

      read response
    end

    def connection
      NetboxClientRuby::Connection.new
    end

    def hash_to_object(hash)
      objectified_class = Class.new
      objectified_instance = objectified_class.new
      hash.each do |k, v|
        variable_name = sanitize_variable_name(k)
        variable_name = "_#{variable_name}" if objectified_instance.methods.map(&:to_s).include?(variable_name)

        objectified_instance.instance_variable_set("@#{variable_name}", v)
        objectified_class.send :define_method, variable_name, proc { instance_variable_get("@#{variable_name}") }
      end
      objectified_instance
    end

    private

    def read(response)
      body = response.body

      body['results'] || body
    end

    def raise_on_http_error(status)
      case status
      when 200..399 then
      when 400..499 then
        raise_on_http_client_error status
      when 500..599 then
        fail NetboxClientRuby::RemoteError, "#{status} Remote Error"
      else
        fail NetboxClientRuby::RemoteError, "#{status} Unknown Error Code"
      end
    end

    def raise_on_http_client_error(status)
      case status
      when 400 then
        fail NetboxClientRuby::ClientError, '400 Bad Request'
      when 401 then
        fail NetboxClientRuby::ClientError, '401 Unauthorized'
      when 403 then
        fail NetboxClientRuby::ClientError, '403 Forbidden'
      when 405 then
        fail NetboxClientRuby::ClientError, '405 Method Not Allowed'
      when 415 then
        fail NetboxClientRuby::ClientError, '415 Unsupported Media Type'
      when 429 then
        fail NetboxClientRuby::ClientError, '429 Too Many Requests'
      else
        fail NetboxClientRuby::ClientError, "#{status} Request Error"
      end
    end

    def sanitize_variable_name(raw_name)
      raw_name.gsub(/[^a-zA-Z0-9_]/, '_')
    end
  end
end
