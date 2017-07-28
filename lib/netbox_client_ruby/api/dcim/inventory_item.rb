require 'netbox_client_ruby/entity'
require 'netbox_client_ruby/api/dcim/device'

module NetboxClientRuby
  module DCIM
    class InventoryItem
      include Entity

      id id: :id
      deletable true
      path 'dcim/inventory-items/:id.json'
      creation_path 'dcim/inventory-items/'
      object_fields device: proc { |raw_data| Device.new raw_data['id'] },
                    manufacturer: proc { |raw_data| Manufacturer.new raw_data['id'] }
    end
  end
end
