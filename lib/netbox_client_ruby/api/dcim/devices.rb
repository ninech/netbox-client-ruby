# frozen_string_literal: true

module NetboxClientRuby
  module DCIM
    class Devices
      include Entities

      path 'dcim/devices/'
      data_key 'results'
      count_key 'count'
      entity_creator :entity_creator

      private

      def entity_creator(raw_entity)
        Device.new raw_entity['id']
      end
    end
  end
end
