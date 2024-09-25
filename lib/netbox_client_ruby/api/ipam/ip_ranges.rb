# frozen_string_literal: true

require 'netbox_client_ruby/entities'
require 'netbox_client_ruby/api/ipam/ip_range'

module NetboxClientRuby
  module IPAM
    class IpRanges
      include Entities

      path 'ipam/ip-ranges.json'
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
