require 'netbox_client_ruby/entities'
require 'netbox_client_ruby/api/dcim/device_type'

module NetboxClientRuby
  class DeviceRoles
    include NetboxClientRuby::Entities

    path 'dcim/device-roles.json'
    data_key 'results'
    count_key 'count'
    entity_creator :entity_creator

    private

    def entity_creator(raw_entity)
      NetboxClientRuby::DeviceRole.new raw_entity['id']
    end
  end
end
