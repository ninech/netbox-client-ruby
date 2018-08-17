require 'netbox_client_ruby/entities'
require 'netbox_client_ruby/api/dcim/virtual_chassis'

module NetboxClientRuby
  module DCIM
    class VirtualChassisList
      include Entities

      path 'dcim/virtual-chassis.json'
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
