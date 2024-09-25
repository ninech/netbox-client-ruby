# frozen_string_literal: true

require 'netbox_client_ruby/entity'
require 'netbox_client_ruby/api/dcim/manufacturer'

module NetboxClientRuby
  module DCIM
    class InterfaceOrdering
      attr_reader :value, :label

      def initialize(raw_data)
        @value = raw_data['value']
        @label = raw_data['label']
      end
    end

    class DeviceType
      include Entity

      id id: :id
      deletable true
      path 'dcim/device-types/:id.json'
      creation_path 'dcim/device-types/'
      object_fields(
        manufacturer: proc { |raw_data| Manufacturer.new raw_data['id'] },
        interface_ordering: InterfaceOrdering
      )
    end
  end
end
