require 'netbox_client_ruby/entities'
require 'netbox_client_ruby/api/dcim/interface_connection'

module NetboxClientRuby
  module DCIM
    class InterfaceConnections
      include Entities

      path 'dcim/interface-connections.json'
      data_key 'results'
      count_key 'count'
      entity_creator :entity_creator

      private

      def entity_creator(raw_entity)
        InterfaceConnection.new raw_entity['id']
      end
    end
  end
end
