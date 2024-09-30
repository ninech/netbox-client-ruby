# frozen_string_literal: true

module NetboxClientRuby
  module Circuits
    class CircuitTerminations
      include Entities

      path 'circuits/circuit-terminations/'
      data_key 'results'
      count_key 'count'
      entity_creator :entity_creator

      private

      def entity_creator(raw_entity)
        CircuitTermination.new raw_entity['id']
      end
    end
  end
end
