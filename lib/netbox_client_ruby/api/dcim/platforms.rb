# frozen_string_literal: true

module NetboxClientRuby
  module DCIM
    class Platforms
      include Entities

      path 'dcim/platforms/'
      data_key 'results'
      count_key 'count'
      entity_creator :entity_creator

      private

      def entity_creator(raw_entity)
        Platform.new raw_entity['id']
      end
    end
  end
end
