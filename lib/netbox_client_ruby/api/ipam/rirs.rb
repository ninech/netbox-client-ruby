require 'netbox_client_ruby/entities'
require 'netbox_client_ruby/api/ipam/rir'

module NetboxClientRuby
  module IPAM
    class Rirs
      include Entities

      path 'ipam/rirs.json'
      data_key 'results'
      count_key 'count'
      entity_creator :entity_creator

      private

      def entity_creator(raw_entity)
        Rir.new raw_entity['id']
      end
    end
  end
end
