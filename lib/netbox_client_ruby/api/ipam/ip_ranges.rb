# frozen_string_literal: true

module NetboxClientRuby
  module IPAM
    class IpRanges
      include Entities

      path 'ipam/ip-ranges/'
      data_key 'results'
      count_key 'count'
      entity_creator :entity_creator

      private

      def entity_creator(raw_entity)
        IpRange.new raw_entity['id']
      end
    end
  end
end
