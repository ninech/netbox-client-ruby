require 'netbox_client_ruby/entities'
require 'netbox_client_ruby/api/dcim/manufacturer'

module NetboxClientRuby
  class Manufacturers
    include NetboxClientRuby::Entities

    path 'dcim/manufacturers.json'
    data_key 'results'
    count_key 'count'
    entity_creator :entity_creator

    private

    def entity_creator(raw_entity)
      NetboxClientRuby::Manufacturer.new raw_entity['id']
    end
  end
end
