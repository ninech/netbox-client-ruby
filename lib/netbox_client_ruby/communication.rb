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

    private

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
