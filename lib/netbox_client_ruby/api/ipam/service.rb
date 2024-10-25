# frozen_string_literal: true

module NetboxClientRuby
  module IPAM
    class Service
      include Entity

      id id: :id
      deletable true
      path 'ipam/services/:id.json'
      creation_path 'ipam/services/'
      object_fields(
        device: proc { |raw_data| Device.new raw_data['id'] },
        virtual_machine: proc { |raw_data| VirtualMachine.new raw_data['id'] },
        protocol: proc { |raw_data| ServiceProtocol.new raw_data },
        ipaddresses: proc { |raw_data| IpAddress.new raw_data['id'] }
      )
      readonly_fields :display_name
    end

    class ServiceProtocol
      attr_reader :value, :label

      def initialize(raw_data)
        @value = raw_data['value']
        @label = raw_data['label']
      end
    end
  end
end
