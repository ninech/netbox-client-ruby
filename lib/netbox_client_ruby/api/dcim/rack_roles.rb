require 'netbox_client_ruby/entities'
require 'netbox_client_ruby/api/dcim/rack_role'

module NetboxClientRuby
  module DCIM
    class RackRoles
      include Entities

      path 'dcim/rack-roles.json'
      data_key 'results'
      count_key 'count'
      entity_creator :entity_creator

      private

      def entity_creator(raw_entity)
        RackRole.new raw_entity['id']
      end
    end
  end
end
