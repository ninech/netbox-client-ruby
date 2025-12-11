# frozen_string_literal: true

module NetboxClientRuby
  module DCIM
    class FrontPorts
      include Entities

      path 'dcim/front-ports/'
      data_key 'results'
      count_key 'count'
      entity_creator :entity_creator

      private

      def entity_creator(raw_entity)
        FrontPort.new raw_entity['id']
      end
    end
  end
end
