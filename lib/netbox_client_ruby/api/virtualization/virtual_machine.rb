require 'netbox_client_ruby/entity'
require 'netbox_client_ruby/api/dcim/device_role'
require 'netbox_client_ruby/api/dcim/platform'
require 'netbox_client_ruby/api/ipam/ip_address'
require 'netbox_client_ruby/api/tenancy/tenant'
require 'netbox_client_ruby/api/virtualization/cluster'

module NetboxClientRuby
  module Virtualization
    class VirtualMachine
      include Entity

      id id: :id
      deletable true
      path 'virtualization/virtual-machines/:id.json'
      creation_path 'virtualization/virtual-machines/'
      object_fields(
        cluster: proc { |raw_data| Cluster.new raw_data['id'] },
        platform: proc { |raw_data| DCIM::Platform.new raw_data['id'] },
        primary_ip: proc { |raw_data| IPAM::IpAddress.new raw_data['id'] },
        primary_ip4: proc { |raw_data| IPAM::IpAddress.new raw_data['id'] },
        primary_ip6: proc { |raw_data| IPAM::IpAddress.new raw_data['id'] },
        role: proc { |raw_data| DCIM::DeviceRole.new raw_data['id'] },
        status: proc { |raw_data| ClusterStatus.new raw_data['value'] },
        tenant: proc { |raw_data| Tenancy::Tenant.new raw_data['id'] },
      )
    end

    class ClusterStatus
      attr_reader :value, :label

      def initialize(status_value)
        @value = status_value
        @label = case status_value
                 when 0
                   'Offline'.freeze
                 when 1
                   'Active'.freeze
                 when 3
                   'Staged'.freeze
                 else
                   'UNDEFINED'.freeze
                 end
      end
    end
  end
end
