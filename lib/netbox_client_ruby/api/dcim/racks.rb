# frozen_string_literal: true

module NetboxClientRuby
  module DCIM
    class Racks
      include Entities

      path 'dcim/racks/'
      data_key 'results'
      count_key 'count'
      entity_creator :entity_creator

      private

      def entity_creator(raw_entity)
        Rack.new raw_entity['id']
      end
    end
  end
end
