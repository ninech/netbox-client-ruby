# frozen_string_literal: true

module NetboxClientRuby
  module IPAM
    class VlanGroups
      include Entities

      path 'ipam/vlan-groups/'
      data_key 'results'
      count_key 'count'
      entity_creator :entity_creator

      private

      def entity_creator(raw_entity)
        VlanGroup.new raw_entity['id']
      end
    end
  end
end
