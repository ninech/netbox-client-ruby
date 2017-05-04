require 'netbox_client_ruby/entity'
require 'netbox_client_ruby/api/dcim/manufacturer'

module NetboxClientRuby
  class DeviceRole
    include NetboxClientRuby::Entity

    id id: :id
    deletable true
    path 'dcim/device-roles/:id.json'
    creation_path 'dcim/device-roles/'

  end
end
