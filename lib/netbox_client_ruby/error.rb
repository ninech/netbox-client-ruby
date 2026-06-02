# frozen_string_literal: true

module NetboxClientRuby
  class Error < StandardError; end
  class ClientError < Error; end
  class LocalError < Error; end
  class RemoteError < Error; end

  ##
  # Raised when a bulk operation (create/update/delete on an array body)
  # returns HTTP 400. NetBox returns either:
  #   * an Array aligned, index by index, to the submitted payload, where each
  #     entry is an empty object (element OK) or a Hash of field => [messages]
  #     (element rejected), or
  #   * a single Hash for a request-level error (e.g. {"detail" => "..."}).
  #
  # +#errors+ exposes the raw structure. +#failures+ zips the rejected
  # elements back to their submitted payload and index, so the caller can map
  # an IDAS batch failure straight back to the offending port/cable.
  class BulkError < ClientError
    attr_reader :errors, :request, :status

    def initialize(message, body: nil, request: nil, status: 400)
      @status = status
      @request = request || []
      @errors = body
      super("#{message} (#{failures.length} element(s) rejected)")
    end

    ##
    # When the body is per-element: an Array of { index:, errors:, item: } for
    # every rejected element only. When the body is a request-level Hash:
    # a single entry with index = nil.
    def failures
      if errors.is_a?(Array)
        errors.each_with_index.filter_map do |element_errors, index|
          next if element_errors.nil? || element_errors.empty?

          { index: index, errors: element_errors, item: request[index] }
        end
      elsif errors.nil? || (errors.respond_to?(:empty?) && errors.empty?)
        []
      else
        [{ index: nil, errors: errors, item: nil }]
      end
    end

    ##
    # True when every submitted element was rejected (or a request-level error).
    def total_failure?
      errors.is_a?(Array) ? failures.length == request.length : !failures.empty?
    end
  end
end
