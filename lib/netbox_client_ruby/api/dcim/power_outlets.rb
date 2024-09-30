# frozen_string_literal: true

module NetboxClientRuby
  module DCIM
    class PowerOutlets
      include Entities

      path 'dcim/power-outlets/'
      data_key 'results'
      count_key 'count'
      entity_creator :entity_creator

      private

      def entity_creator(raw_entity)
        PowerOutlet.new raw_entity['id']
      end
    end
  end
end
