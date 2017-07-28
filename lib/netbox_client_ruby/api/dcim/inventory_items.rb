require 'netbox_client_ruby/entities'
require 'netbox_client_ruby/api/dcim/inventory_item'

module NetboxClientRuby
  class InventoryItems
    include NetboxClientRuby::Entities

    path 'dcim/inventory-items.json'
    data_key 'results'
    count_key 'count'
    entity_creator :entity_creator

    private

    def entity_creator(raw_entity)
      NetboxClientRuby::InventoryItem.new raw_entity['id']
    end
  end
end
