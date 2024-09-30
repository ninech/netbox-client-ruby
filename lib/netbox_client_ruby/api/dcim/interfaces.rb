# frozen_string_literal: true

module NetboxClientRuby
  module DCIM
    class Interfaces
      include Entities

      path 'dcim/interfaces/'
      data_key 'results'
      count_key 'count'
      entity_creator :entity_creator

      private

      def entity_creator(raw_entity)
        Interface.new raw_entity['id']
      end
    end
  end
end
