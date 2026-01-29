# frozen_string_literal: true

module NetboxClientRuby
  module DCIM
    class Cables
      include Entities

      path 'dcim/cables/'
      data_key 'results'
      count_key 'count'
      entity_creator :entity_creator

      private

      def entity_creator(raw_entity)
        Cable.new raw_entity['id']
      end
    end
  end
end
