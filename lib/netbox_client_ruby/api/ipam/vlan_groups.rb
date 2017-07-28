require 'netbox_client_ruby/entities'
require 'netbox_client_ruby/api/ipam/vlan_group'

module NetboxClientRuby
  module IPAM
    class VlanGroups
      include Entities

      path 'ipam/vlan-groups.json'
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
