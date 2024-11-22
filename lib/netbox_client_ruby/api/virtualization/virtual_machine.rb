# frozen_string_literal: true

module NetboxClientRuby
  module Virtualization
    class VirtualMachine
      include Entity

      id id: :id
      deletable true
      path 'virtualization/virtual-machines/:id/'
      creation_path 'virtualization/virtual-machines/'
      object_fields(
        cluster: proc { |raw_data| Cluster.new raw_data['id'] },
        platform: proc { |raw_data| DCIM::Platform.new raw_data['id'] },
        primary_ip: proc { |raw_data| IPAM::IpAddress.new raw_data['id'] },
        primary_ip4: proc { |raw_data| IPAM::IpAddress.new raw_data['id'] },
        primary_ip6: proc { |raw_data| IPAM::IpAddress.new raw_data['id'] },
        role: proc { |raw_data| DCIM::DeviceRole.new raw_data['id'] },
        status: proc { |raw_data| ClusterStatus.new raw_data },
        tenant: proc { |raw_data| Tenancy::Tenant.new raw_data['id'] },
      )
    end

    class ClusterStatus
      attr_reader :value, :label

      def initialize(raw_data)
        @value = raw_data['value']
        @label = raw_data['label']
      end
    end
  end
end
