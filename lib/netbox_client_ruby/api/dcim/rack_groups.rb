# frozen_string_literal: true

module NetboxClientRuby
  module DCIM
    class RackGroups
      include Entities

      path 'dcim/rack-groups/'
      data_key 'results'
      count_key 'count'
      entity_creator :entity_creator

      private

      def entity_creator(raw_entity)
        RackGroup.new raw_entity['id']
      end
    end
  end
end
