# frozen_string_literal: true

module NetboxClientRuby
  module DCIM
    class VirtualChassisList
      include Entities

      path 'dcim/virtual-chassis/'
      data_key 'results'
      count_key 'count'
      entity_creator :entity_creator

      private

      def entity_creator(raw_entity)
        VirtualChassis.new raw_entity['id']
      end
    end
  end
end
