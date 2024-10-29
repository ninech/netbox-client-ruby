# frozen_string_literal: true

module NetboxClientRuby
  module IPAM
    class IpAddress
      include Entity

      STATUS_VALUES = {
        active: 1,
        reserved: 2,
        deprecated: 3,
        dhcp: 5
      }.freeze

      id id: :id
      deletable true
      path 'ipam/ip-addresses/:id.json'
      creation_path 'ipam/ip-addresses/'
      object_fields(
        vrf: proc { |raw_data| Vrf.new raw_data['id'] },
        tenant: proc { |raw_data| Tenancy::Tenant.new raw_data['id'] },
        status: proc { |raw_data| STATUS_VALUES.key(raw_data['value']) || raw_data['value'] },
        address: proc { |raw_ip| IPAddress.parse(raw_ip) }
      )
      readonly_fields :display_name

      def status=(value)
        status_code_lookup = STATUS_VALUES.fetch(value, value)
        method_missing(:status=, status_code_lookup)
      end

      def interface
        interface_data = data['interface']

        return nil unless interface_data
        return Virtualization::Interface.new interface_data['id'] unless interface_data.dig('virtual_machine').nil?
        return DCIM::Interface.new interface_data['id']
      end
    end
  end
end
