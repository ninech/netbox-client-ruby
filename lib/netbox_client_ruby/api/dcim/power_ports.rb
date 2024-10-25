# frozen_string_literal: true

module NetboxClientRuby
  module DCIM
    class PowerPorts
      include Entities

      path 'dcim/power-ports/'
      data_key 'results'
      count_key 'count'
      entity_creator :entity_creator

      private

      def entity_creator(raw_entity)
        PowerPort.new raw_entity['id']
      end
    end
  end
end
