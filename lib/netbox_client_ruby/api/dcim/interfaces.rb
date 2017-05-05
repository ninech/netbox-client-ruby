require 'netbox_client_ruby/entities'
require 'netbox_client_ruby/api/dcim/interface'

module NetboxClientRuby
  class Interfaces
    include NetboxClientRuby::Entities

    path 'dcim/interfaces.json'
    data_key 'results'
    count_key 'count'
    entity_creator :entity_creator

    private

    def entity_creator(raw_entity)
      NetboxClientRuby::Interface.new raw_entity['id']
    end
  end
end
