# frozen_string_literal: true

module NetboxClientRuby
  module DCIM
    class ConsoleConnections
      include Entities

      path 'dcim/console-connections/'
      data_key 'results'
      count_key 'count'
      entity_creator :entity_creator

      private

      def entity_creator(raw_entity)
        ConsoleConnection.new raw_entity['id']
      end
    end
  end
end
