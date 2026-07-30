# frozen_string_literal: true

module NetboxClientRuby
  class Error < StandardError
    class LocalError < Error; end
    class ClientError < Error; end
    class RemoteError < Error; end
  end
end
