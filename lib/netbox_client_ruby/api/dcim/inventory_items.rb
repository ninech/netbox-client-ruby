require 'netbox_client_ruby/entities'
require 'netbox_client_ruby/api/dcim/inventory_item'

module NetboxClientRuby
  module DCIM
    class InventoryItems
      include Entities

      path 'dcim/inventory-items.json'
      data_key 'results'
      count_key 'count'
      entity_creator :entity_creator

      private

      def entity_creator(raw_entity)
        InventoryItem.new raw_entity['id']
      end
    end
  end
end
