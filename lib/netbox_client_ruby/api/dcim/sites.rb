require 'netbox_client_ruby/entities'
require 'netbox_client_ruby/api/dcim/site'
require 'uri'

module NetboxClientRuby
  class Sites
    include NetboxClientRuby::Entities

    path 'dcim/sites.json'
    data_key 'results'
    count_key 'count'
    entity_creator :entity_creator

    private

    def entity_creator(raw_entity)
      NetboxClientRuby::Site.new raw_entity['id']
    end
  end
end
