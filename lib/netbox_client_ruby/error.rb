# frozen_string_literal: true

module NetboxClientRuby
  class Error < StandardError; end
  class ClientError < Error; end
  class LocalError < Error; end
  class RemoteError < Error; end
end
