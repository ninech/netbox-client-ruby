require 'netbox_client_ruby/entities'
require 'netbox_client_ruby/api/dcim/rack'

module NetboxClientRuby
  class Racks
    include NetboxClientRuby::Entities

    path 'dcim/racks.json'
    data_key 'results'
    count_key 'count'
    entity_creator :entity_creator

    private

    def entity_creator(raw_entity)
      NetboxClientRuby::Rack.new raw_entity['id']
    end
  end
end
