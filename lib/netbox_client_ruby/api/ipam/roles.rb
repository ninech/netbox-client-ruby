require 'netbox_client_ruby/entities'
require 'netbox_client_ruby/api/ipam/role'
require 'uri'

module NetboxClientRuby
  class Roles
    include NetboxClientRuby::Entities

    path 'ipam/roles.json'
    data_key 'results'
    count_key 'count'
    entity_creator :entity_creator

    private

    def entity_creator(raw_entity)
      NetboxClientRuby::Role.new raw_entity['id']
    end
  end
end
