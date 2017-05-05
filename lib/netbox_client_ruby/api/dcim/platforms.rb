require 'netbox_client_ruby/entities'
require 'netbox_client_ruby/api/dcim/platform'

module NetboxClientRuby
  class Platforms
    include NetboxClientRuby::Entities

    path 'dcim/platforms.json'
    data_key 'results'
    count_key 'count'
    entity_creator :entity_creator

    private

    def entity_creator(raw_entity)
      NetboxClientRuby::Platform.new raw_entity['id']
    end
  end
end
