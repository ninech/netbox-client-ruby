require 'netbox_client_ruby/entities'
require 'netbox_client_ruby/api/dcim/rack_group'

module NetboxClientRuby
  module DCIM
    class RackGroups
      include Entities

      path 'dcim/rack-groups.json'
      data_key 'results'
      count_key 'count'
      entity_creator :entity_creator

      private

      def entity_creator(raw_entity)
        RackGroup.new raw_entity['id']
      end
    end
  end
end
