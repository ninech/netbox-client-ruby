require 'netbox_client_ruby/entities'
require 'netbox_client_ruby/api/ipam/vrf'

module NetboxClientRuby
  module IPAM
    class Vrfs
      include Entities

      path 'ipam/vrfs.json'
      data_key 'results'
      count_key 'count'
      entity_creator :entity_creator

      private

      def entity_creator(raw_entity)
        Vrf.new raw_entity['id']
      end
    end
  end
end
