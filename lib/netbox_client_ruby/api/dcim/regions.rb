# frozen_string_literal: true

module NetboxClientRuby
  module DCIM
    class Regions
      include Entities

      path 'dcim/regions/'
      data_key 'results'
      count_key 'count'
      entity_creator :entity_creator

      private

      def entity_creator(raw_entity)
        Region.new raw_entity['id']
      end
    end
  end
end
