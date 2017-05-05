require 'netbox_client_ruby/entities'
require 'netbox_client_ruby/api/dcim/device'

module NetboxClientRuby
  class Devices
    include NetboxClientRuby::Entities

    path 'dcim/devices.json'
    data_key 'results'
    count_key 'count'
    entity_creator :entity_creator

    private

    def entity_creator(raw_entity)
      NetboxClientRuby::Device.new raw_entity['id']
    end
  end
end
