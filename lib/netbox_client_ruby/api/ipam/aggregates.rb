require 'netbox_client_ruby/entities'
require 'netbox_client_ruby/api/ipam/aggregate'

module NetboxClientRuby
  module IPAM
    class Aggregates
      include Entities

      path 'ipam/aggregates.json'
      data_key 'results'
      count_key 'count'
      entity_creator :entity_creator

      private

      def entity_creator(raw_entity)
        Aggregate.new raw_entity['id']
      end
    end
  end
end
