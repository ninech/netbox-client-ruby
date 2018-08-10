require 'netbox_client_ruby/entities'
require 'netbox_client_ruby/api/circuits/circuit_type'

module NetboxClientRuby
  module Circuits
    class CircuitTypes
      include Entities

      path 'circuits/circuit-types.json'
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
