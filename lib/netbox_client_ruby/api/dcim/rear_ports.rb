# frozen_string_literal: true

module NetboxClientRuby
  module DCIM
    class RearPorts
      include Entities

      path 'dcim/rear-ports/'
      data_key 'results'
      count_key 'count'
      entity_creator :entity_creator

      private

      def entity_creator(raw_entity)
        RearPort.new raw_entity['id']
      end
    end
  end
end
