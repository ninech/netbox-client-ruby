# frozen_string_literal: true

module NetboxClientRuby
  module IPAM
    class IpRange
      include Entity

      id id: :id
      deletable true
      path 'ipam/ip-ranges/:id.json'
      creation_path 'ipam/ip-ranges/'
      object_fields(
        vrf: proc { |raw_data| Vrf.new raw_data['id'] },
        tenant: proc { |raw_data| Tenancy::Tenant.new raw_data['id'] },
        role: proc { |raw_data| Role.new raw_data['id'] },
        status: proc { |raw_data| IpRangeStatus.new raw_data },
        start_address: proc { |raw_data| IPAddress.parse raw_data },
        end_address: proc { |raw_data| IPAddress.parse raw_data }
      )
    end

    class IpRangeStatus
      attr_reader :value, :label

      def initialize(raw_data)
        @value = raw_data['value']
        @label = raw_data['label']
      end
    end
  end
end
