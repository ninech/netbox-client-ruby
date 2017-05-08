require 'netbox_client_ruby/api/dcim/device'
require 'netbox_client_ruby/api/dcim/devices'
require 'netbox_client_ruby/api/dcim/device_role'
require 'netbox_client_ruby/api/dcim/device_roles'
require 'netbox_client_ruby/api/dcim/device_type'
require 'netbox_client_ruby/api/dcim/device_types'
require 'netbox_client_ruby/api/dcim/interface'
require 'netbox_client_ruby/api/dcim/interfaces'
require 'netbox_client_ruby/api/dcim/manufacturer'
require 'netbox_client_ruby/api/dcim/manufacturers'
require 'netbox_client_ruby/api/dcim/platform'
require 'netbox_client_ruby/api/dcim/platforms'
require 'netbox_client_ruby/api/dcim/rack'
require 'netbox_client_ruby/api/dcim/racks'
require 'netbox_client_ruby/api/dcim/region'
require 'netbox_client_ruby/api/dcim/regions'
require 'netbox_client_ruby/api/dcim/site'
require 'netbox_client_ruby/api/dcim/sites'
require 'netbox_client_ruby/communication'

module NetboxClientRuby
  class DCIM
    {
      devices: Devices,
      device_roles: DeviceRoles,
      device_types: DeviceTypes,
      interfaces: Interfaces,
      manufacturers: Manufacturers,
      platforms: Platforms,
      racks: Racks,
      regions: Regions,
      sites: Sites
    }.each_pair do |method_name, class_name|
      define_method(method_name) do
        class_name.new
      end
    end

    {
      device: Device,
      device_role: DeviceRole,
      device_type: DeviceType,
      interface: Interface,
      manufacturer: Manufacturer,
      platform: Platform,
      rack: Rack,
      region: Region,
      site: Site
    }.each_pair do |method_name, class_name|
      define_method(method_name) do |id|
        class_name.new id
      end
    end
  end
end
