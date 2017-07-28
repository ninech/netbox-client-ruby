require 'netbox_client_ruby/entities'
require 'netbox_client_ruby/api/ipam/ip_address'

module NetboxClientRuby
  module IPAM
    class IpAddresses
      include Entities

      path 'ipam/ip-addresses.json'
      data_key 'results'
      count_key 'count'
      entity_creator :entity_creator

      private

      def entity_creator(raw_entity)
        IpAddress.new raw_entity['id']
      end
    end
  end
end
