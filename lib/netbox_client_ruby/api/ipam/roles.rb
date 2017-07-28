require 'netbox_client_ruby/entities'
require 'netbox_client_ruby/api/ipam/role'

module NetboxClientRuby
  module IPAM
    class Roles
      include Entities

      path 'ipam/roles.json'
      data_key 'results'
      count_key 'count'
      entity_creator :entity_creator

      private

      def entity_creator(raw_entity)
        Role.new raw_entity['id']
      end
    end
  end
end
