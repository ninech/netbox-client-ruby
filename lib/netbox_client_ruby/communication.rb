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

    def raise_on_http_error(response) # rubocop:disable Metrics/MethodLength
      status = response.status
      body = response.body

      case status
      when 200..299
        # do nothing
      when 300..499
        raise_on_http_client_error response
      when 500..599
        raise NetboxClientRuby::Error::RemoteError, "#{status} Remote Error#{formatted_body(body)}"
      else
        raise NetboxClientRuby::Error::RemoteError, "#{status} Unknown Error Code#{formatted_body(body)}"
      end
    end

    def raise_on_http_client_error(response) # rubocop:disable Metrics/MethodLength
      status = response.status
      body = response.body

      case status
      when 400
        raise_client_error '400 Bad Request', body
      when 401
        raise_client_error '401 Unauthorized', body
      when 403
        raise_client_error '403 Forbidden', body
      when 405
        raise_client_error '405 Method Not Allowed', body
      when 415
        raise_client_error '415 Unsupported Media Type', body
      when 429
        raise_client_error '429 Too Many Requests', body
      else
        raise_client_error "#{status} Request Error", body
      end
    end

    def raise_client_error(message, body = nil)
      raise NetboxClientRuby::Error::ClientError, "#{message}#{formatted_body(body)}"
    end

    def formatted_body(body)
      return '' if body.nil? || body.empty?

      shortened = body.to_s
      one_line = shortened.gsub(/\n/, '\n')
      " (#{one_line})"
    end
  end
end
