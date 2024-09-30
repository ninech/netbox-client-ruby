# frozen_string_literal: true

module NetboxClientRuby
  module DCIM
    class DeviceRoles
      include Entities

      path 'dcim/device-roles/'
      data_key 'results'
      count_key 'count'
      entity_creator :entity_creator

      private

      def entity_creator(raw_entity)
        DeviceRole.new raw_entity['id']
      end
    end
  end
end
