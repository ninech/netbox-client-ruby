# frozen_string_literal: true

module NetboxClientRuby
  module Circuits
    ##
    # This allows to access a list of Netbox Circuits.
    #
    # Normally, this class would be called `Circuits`.
    # But this conflicts with the module of the same name.
    class Circuits
      include Entities

      path 'circuits/circuits/'
      data_key 'results'
      count_key 'count'
      entity_creator :entity_creator

      private

      def entity_creator(raw_entity)
        Circuit.new raw_entity['id']
      end
    end
  end
end
