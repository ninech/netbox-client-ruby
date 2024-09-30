# frozen_string_literal: true

module NetboxClientRuby
  module Circuits
    class CircuitTypes
      include Entities

      path 'circuits/circuit-types/'
      data_key 'results'
      count_key 'count'
      entity_creator :entity_creator

      private

      def entity_creator(raw_entity)
        CircuitType.new raw_entity['id']
      end
    end
  end
end
