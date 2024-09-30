# frozen_string_literal: true

module NetboxClientRuby
  module DCIM
    class RackRoles
      include Entities

      path 'dcim/rack-roles/'
      data_key 'results'
      count_key 'count'
      entity_creator :entity_creator

      private

      def entity_creator(raw_entity)
        RackRole.new raw_entity['id']
      end
    end
  end
end
