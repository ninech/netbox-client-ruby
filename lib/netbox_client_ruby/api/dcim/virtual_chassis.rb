require 'netbox_client_ruby/entity'
require 'netbox_client_ruby/api/dcim/device'

module NetboxClientRuby
  module DCIM
    class VirtualChassis
      include Entity

      id id: :id
      deletable true
      path 'dcim/virtual-chassis/:id.json'
      creation_path 'dcim/virtual-chassis/'

      object_fields(
        master: proc { |raw_data| Device.new raw_data['id'] },
      )
    end
  end
end
