# frozen_string_literal: true

module NetboxClientRuby
  module DCIM
    class MacAddresses
      include Entities

      path 'dcim/mac-addresses/'
      data_key 'results'
      count_key 'count'
      entity_creator :entity_creator

      private

      def entity_creator(raw_entity)
        MacAddress.new raw_entity['id']
      end
    end
  end
end
