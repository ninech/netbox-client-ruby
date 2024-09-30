# frozen_string_literal: true

module NetboxClientRuby
  module Circuits
    class Providers
      include Entities

      path 'circuits/providers/'
      data_key 'results'
      count_key 'count'
      entity_creator :entity_creator

      private

      def entity_creator(raw_entity)
        Provider.new raw_entity['id']
      end
    end
  end
end
