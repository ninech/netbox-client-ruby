require 'netbox_client_ruby/entities'
require 'netbox_client_ruby/api/ipam/vlan'

module NetboxClientRuby
  class Vlans
    include NetboxClientRuby::Entities

    path 'ipam/vlans.json'
    data_key 'results'
    count_key 'count'
    entity_creator :entity_creator

    private

    def entity_creator(raw_entity)
      NetboxClientRuby::Vlan.new raw_entity['id']
    end
  end
end
