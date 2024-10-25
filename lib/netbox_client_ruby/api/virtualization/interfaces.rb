# frozen_string_literal: true

module NetboxClientRuby
  module Virtualization
    class Interfaces
      include Entities

      path 'virtualization/interfaces/'
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
