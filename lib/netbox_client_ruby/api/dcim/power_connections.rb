require 'netbox_client_ruby/entities'
require 'netbox_client_ruby/api/dcim/power_connection'

module NetboxClientRuby
  module DCIM
    class PowerConnections
      include Entities

      path 'dcim/power-connections.json'
      data_key 'results'
      count_key 'count'
      entity_creator :entity_creator

      private

      def entity_creator(raw_entity)
        PowerConnection.new raw_entity['id']
      end
    end
  end
end
