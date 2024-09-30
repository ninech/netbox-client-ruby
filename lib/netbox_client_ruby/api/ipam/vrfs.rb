# frozen_string_literal: true

module NetboxClientRuby
  module IPAM
    class Vrfs
      include Entities

      path 'ipam/vrfs/'
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
