# frozen_string_literal: true

module NetboxClientRuby
  module Core
    ##
    # /api/core/object-changes/ — the change log used for incremental polling.
    #
    # Supports the standard filterable/paginated reads via #get_list, e.g.
    # multiple changed_object_type_id, time_after, ordering, limit/offset, and
    # the all-pages aggregation inherited from Entities (#all_pages).
    class ObjectChanges
      include Entities

      path 'core/object-changes/'
      data_key 'results'
      count_key 'count'
      entity_creator :entity_creator

      private

      def entity_creator(raw_entity)
        ObjectChange.new raw_entity['id']
      end
    end
  end
end
