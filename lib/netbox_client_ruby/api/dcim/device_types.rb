require 'netbox_client_ruby/entities'
require 'netbox_client_ruby/api/dcim/device_type'

module NetboxClientRuby
  module DCIM
    class DeviceTypes
      include Entities

      path 'dcim/device-types.json'
      data_key 'results'
      count_key 'count'
      entity_creator :entity_creator

      private

      def entity_creator(raw_entity)
        DeviceType.new raw_entity['id']
      end
    end
  end
end
