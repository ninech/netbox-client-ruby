# frozen_string_literal: true

module NetboxClientRuby
  ##
  # Bulk create / update / delete against a collection endpoint, using an array
  # request body (NetBox's native bulk mode). Mixed into Entities, so every
  # collection (dcim.cables, dcim.front_ports, ...) gains these methods.
  #
  # Semantics (Exigence A):
  #   * +bulk_create+ / +bulk_update+ return the FULL objects sent back by
  #     NetBox, wrapped as entities, so the caller can read the assigned +id+.
  #   * +bulk_update+ requires an +id+ on every element (PATCH semantics).
  #   * +bulk_delete+ accepts ids, hashes, or entities; sends [{id: ...}, ...].
  #   * an HTTP 400 raises NetboxClientRuby::BulkError, whose +#failures+ maps
  #     each rejected element back to its submitted payload and index.
  module BulkOperations
    include NetboxClientRuby::Communication

    def bulk_create(objects)
      payload = normalize_payload(objects)
      wrap_entities bulk_request(:post, payload), payload
    end

    def bulk_update(objects)
      payload = normalize_payload(objects)
      payload.each_with_index do |element, index|
        unless element.is_a?(Hash) && (element['id'] || element[:id])
          raise NetboxClientRuby::LocalError,
                "bulk_update: element ##{index} is missing an 'id'."
        end
      end
      wrap_entities bulk_request(:patch, payload), payload
    end

    def bulk_delete(objects)
      payload = Array(objects).map { |object| { id: extract_id(object) } }
      bulk_request(:delete, payload)
      payload.length
    end

    private

    def bulk_path
      self.class.path
    end

    def normalize_payload(objects)
      raise ArgumentError, 'A bulk operation expects an Array.' unless objects.is_a?(Array)

      objects.map { |object| object.respond_to?(:raw_data!) ? object.raw_data! : object }
    end

    def extract_id(object)
      return object['id'] || object[:id] if object.is_a?(Hash)
      return object.id if object.respond_to?(:id)

      object
    end

    def bulk_request(method, payload)
      faraday_response =
        if method == :delete
          connection.delete(bulk_path) { |request| request.body = payload }
        else
          connection.public_send(method, bulk_path, payload)
        end

      handle_bulk_response(faraday_response, payload)
    end

    def handle_bulk_response(faraday_response, payload)
      status = faraday_response.status
      return [] if status == 204

      if status == 400
        raise NetboxClientRuby::BulkError.new(
          'Bulk operation rejected', body: faraday_response.body, request: payload
        )
      end

      # Delegates 2xx / other errors to the shared Communication handling.
      response faraday_response
    end

    ##
    # NetBox returns the full objects (with ids) for create/update. Reuse the
    # collection's entity_creator so callers get real entity instances.
    def wrap_entities(raw_objects, _payload)
      return raw_objects unless raw_objects.is_a?(Array)
      return raw_objects unless respond_to?(:as_entity, true)

      raw_objects.map { |raw_object| as_entity(raw_object) }
    end
  end
end
