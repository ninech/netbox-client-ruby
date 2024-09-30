# frozen_string_literal: true

module NetboxClientRuby
  module DCIM
    class Sites
      include Entities

      path 'dcim/sites/'
      data_key 'results'
      count_key 'count'
      entity_creator :entity_creator

      private

      def entity_creator(raw_entity)
        Site.new raw_entity['id']
      end
    end
  end
end
