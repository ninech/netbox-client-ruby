require 'netbox_client_ruby/api/dcim/device'
require 'netbox_client_ruby/api/dcim/devices'
require 'netbox_client_ruby/api/dcim/device_role'
require 'netbox_client_ruby/api/dcim/device_roles'
require 'netbox_client_ruby/api/dcim/device_type'
require 'netbox_client_ruby/api/dcim/device_types'
require 'netbox_client_ruby/api/dcim/manufacturer'
require 'netbox_client_ruby/api/dcim/manufacturers'
require 'netbox_client_ruby/api/dcim/region'
require 'netbox_client_ruby/api/dcim/regions'
require 'netbox_client_ruby/api/dcim/site'
require 'netbox_client_ruby/api/dcim/sites'
require 'netbox_client_ruby/communication'

module NetboxClientRuby
  class DCIM
    {
      sites: Sites,
      regions: Regions,
      manufacturers: Manufacturers,
      device_types: DeviceTypes,
      device_roles: DeviceRoles,
      devices: Devices,
    }.each_pair do |method_name, class_name|
      define_method(method_name) do
        class_name.new
      end
    end

    {
      site: Site,
      region: Region,
      manufacturer: Manufacturer,
      device_type: DeviceType,
      device_role: DeviceRole,
      device: Device,
    }.each_pair do |method_name, class_name|
      define_method(method_name) do |id|
        class_name.new id
      end
    end
  end
end
