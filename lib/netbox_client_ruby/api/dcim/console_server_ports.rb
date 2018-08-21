require 'netbox_client_ruby/entities'
require 'netbox_client_ruby/api/dcim/console_server_port'

module NetboxClientRuby
  module DCIM
    class ConsoleServerPorts
      include Entities

      path 'dcim/console-server-ports.json'
      data_key 'results'
      count_key 'count'
      entity_creator :entity_creator

      private

      def entity_creator(raw_entity)
        ConsoleServerPort.new raw_entity['id']
      end
    end
  end
end
