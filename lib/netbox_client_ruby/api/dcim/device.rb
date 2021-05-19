require 'netbox_client_ruby/entity'
require 'netbox_client_ruby/api/dcim/device_type'
require 'netbox_client_ruby/api/dcim/device_role'
require 'netbox_client_ruby/api/tenancy/tenant'
require 'netbox_client_ruby/api/dcim/platform'
require 'netbox_client_ruby/api/dcim/site'
require 'netbox_client_ruby/api/dcim/rack'
require 'netbox_client_ruby/api/dcim/virtual_chassis'
require 'netbox_client_ruby/api/ipam/ip_address'

module NetboxClientRuby
  module DCIM
    class Device
      include Entity

      id id: :id
      deletable true
      path 'dcim/devices/:id.json'
      creation_path 'dcim/devices/'
      object_fields(
        device_type: proc { |raw_data| DeviceType.new raw_data['id'] },
        device_role: proc { |raw_data| DeviceRole.new raw_data['id'] },
        tenant: proc { |raw_data| Tenancy::Tenant.new raw_data['id'] },
        platform: proc { |raw_data| Platform.new raw_data['id'] },
        site: proc { |raw_data| Site.new raw_data['id'] },
        rack: proc { |raw_data| Rack.new raw_data['id'] },
        parent_device: proc { |raw_data| Device.new raw_data['id'] },
        primary_ip: proc { |raw_data| IPAM::IpAddress.new raw_data['id'] },
        primary_ip4: proc { |raw_data| IPAM::IpAddress.new raw_data['id'] },
        primary_ip6: proc { |raw_data| IPAM::IpAddress.new raw_data['id'] },
        virtual_chassis: proc { |raw_data| DCIM::VirtualChassis.new raw_data['id'] },
        tags: proc { |raw_data| Extras::Tag.new raw_data['id'] },
      )
    end
  end
end
