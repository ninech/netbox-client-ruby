require 'netbox_client_ruby/entity'
require 'netbox_client_ruby/api/dcim/device_type'
require 'netbox_client_ruby/api/dcim/device_role'
require 'netbox_client_ruby/api/tenancy/tenant'
require 'netbox_client_ruby/api/dcim/platform'
require 'netbox_client_ruby/api/dcim/site'
require 'netbox_client_ruby/api/dcim/rack'
require 'netbox_client_ruby/api/ipam/ip_address'

module NetboxClientRuby
  class Device
    include NetboxClientRuby::Entity

    id id: :id
    deletable true
    path 'dcim/devices/:id.json'
    creation_path 'dcim/devices/'
    object_fields(
      device_type: proc { |raw_data| NetboxClientRuby::DeviceType.new raw_data['id'] },
      device_role: proc { |raw_data| NetboxClientRuby::DeviceRole.new raw_data['id'] },
      tenant: proc { |raw_data| NetboxClientRuby::Tenant.new raw_data['id'] },
      platform: proc { |raw_data| NetboxClientRuby::Platform.new raw_data['id'] },
      site: proc { |raw_data| NetboxClientRuby::Site.new raw_data['id'] },
      rack: proc { |raw_data| NetboxClientRuby::Rack.new raw_data['id'] },
      parent_device: proc { |raw_data| NetboxClientRuby::Device.new raw_data['id'] },
      primary_ip: proc { |raw_data| NetboxClientRuby::IpAddress.new raw_data['id'] },
      primary_ip4: proc { |raw_data| NetboxClientRuby::IpAddress.new raw_data['id'] },
      primary_ip6: proc { |raw_data| NetboxClientRuby::IpAddress.new raw_data['id'] }
    )
  end
end
