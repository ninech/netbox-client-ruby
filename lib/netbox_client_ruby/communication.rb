# frozen_string_literal: true

module NetboxClientRuby
  module Communication
    def response(response)
      return nil if response.status == 304
      return {} if response.status == 204

      raise_on_http_error response

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

        objectified_instance.instance_variable_set(:"@#{variable_name}", v)
        objectified_class.send(:define_method, variable_name, proc { instance_variable_get(:"@#{variable_name}") })
      end
      objectified_instance
    end

    private

    def sanitize_variable_name(raw_name)
      raw_name.gsub(/[^a-zA-Z0-9_]/, '_')
    end

    def read(response)
      response.body
    end

    def raise_on_http_error(response)
      status = response.status
      body = response.body

      case status
      when 200..299 then
      when 300..499 then
        raise_on_http_client_error response
      when 500..599 then
        raise NetboxClientRuby::RemoteError, "#{status} Remote Error#{formatted_body(body)}"
      else
        raise NetboxClientRuby::RemoteError, "#{status} Unknown Error Code#{formatted_body(body)}"
      end
    end

    def raise_on_http_client_error(response)
      status = response.status
      body = response.body

      case status
      when 400 then
        raise_client_error '400 Bad Request', body
      when 401 then
        raise_client_error '401 Unauthorized', body
      when 403 then
        raise_client_error '403 Forbidden', body
      when 405 then
        raise_client_error '405 Method Not Allowed', body
      when 415 then
        raise_client_error '415 Unsupported Media Type', body
      when 429 then
        raise_client_error '429 Too Many Requests', body
      else
        raise_client_error "#{status} Request Error", body
      end
    end

    def raise_client_error(message, body = nil)
      raise NetboxClientRuby::ClientError, "#{message}#{formatted_body(body)}"
    end

    def formatted_body(body)
      return '' if body.nil? || body.empty?
      shortened = body.to_s
      one_line = shortened.gsub(/\n/, '\n')
      " (#{one_line})"
    end
  end
end
