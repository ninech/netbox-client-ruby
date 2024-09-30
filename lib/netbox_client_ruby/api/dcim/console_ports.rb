# frozen_string_literal: true

module NetboxClientRuby
  module DCIM
    class ConsolePorts
      include Entities

      path 'dcim/console-ports/'
      data_key 'results'
      count_key 'count'
      entity_creator :entity_creator

      private

      def entity_creator(raw_entity)
        ConsolePort.new raw_entity['id']
      end
    end
  end
end
