# frozen_string_literal: true

module NetboxClientRuby
  module DCIM
    class Manufacturers
      include Entities

      path 'dcim/manufacturers/'
      data_key 'results'
      count_key 'count'
      entity_creator :entity_creator

      private

      def entity_creator(raw_entity)
        Manufacturer.new raw_entity['id']
      end
    end
  end
end
