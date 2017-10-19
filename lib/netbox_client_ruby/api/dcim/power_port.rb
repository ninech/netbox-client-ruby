require 'netbox_client_ruby/entity'
require 'netbox_client_ruby/api/dcim/device'
require 'netbox_client_ruby/api/dcim/power_outlet'

module NetboxClientRuby
  module DCIM
    class PowerPort
      include Entity

      id id: :id
      deletable true
      path 'dcim/power-ports/:id.json'
      creation_path 'dcim/power-ports/'
      object_fields device: proc { |raw_data| Device.new raw_data['id'] }
      object_fields power_outlet: proc { |raw_data| PowerOutlet.new raw_data['id'] }
    end
  end
end
