require 'netbox_client_ruby/api/dcim/device'
require 'netbox_client_ruby/api/dcim/devices'
require 'netbox_client_ruby/api/dcim/device_role'
require 'netbox_client_ruby/api/dcim/device_roles'
require 'netbox_client_ruby/api/dcim/device_type'
require 'netbox_client_ruby/api/dcim/device_types'
require 'netbox_client_ruby/api/dcim/interface'
require 'netbox_client_ruby/api/dcim/interfaces'
require 'netbox_client_ruby/api/dcim/inventory_item'
require 'netbox_client_ruby/api/dcim/inventory_items'
require 'netbox_client_ruby/api/dcim/manufacturer'
require 'netbox_client_ruby/api/dcim/manufacturers'
require 'netbox_client_ruby/api/dcim/platform'
require 'netbox_client_ruby/api/dcim/platforms'
require 'netbox_client_ruby/api/dcim/power_outlet'
require 'netbox_client_ruby/api/dcim/power_outlets'
require 'netbox_client_ruby/api/dcim/power_port'
require 'netbox_client_ruby/api/dcim/power_ports'
require 'netbox_client_ruby/api/dcim/rack'
require 'netbox_client_ruby/api/dcim/rack_group'
require 'netbox_client_ruby/api/dcim/rack_groups'
require 'netbox_client_ruby/api/dcim/rack_role'
require 'netbox_client_ruby/api/dcim/rack_roles'
require 'netbox_client_ruby/api/dcim/racks'
require 'netbox_client_ruby/api/dcim/region'
require 'netbox_client_ruby/api/dcim/regions'
require 'netbox_client_ruby/api/dcim/site'
require 'netbox_client_ruby/api/dcim/sites'
require 'netbox_client_ruby/communication'

module NetboxClientRuby
  module DCIM
    {
      devices: Devices,
      device_roles: DeviceRoles,
      device_types: DeviceTypes,
      interfaces: Interfaces,
      inventory_items: InventoryItems,
      manufacturers: Manufacturers,
      platforms: Platforms,
      power_outlets: PowerOutlets,
      power_ports: PowerPorts,
      racks: Racks,
      rack_groups: RackGroups,
      rack_roles: RackRoles,
      regions: Regions,
      sites: Sites
    }.each_pair do |method_name, class_name|
      define_method(method_name) { class_name.new }
      module_function(method_name)
    end

    {
      device: Device,
      device_role: DeviceRole,
      device_type: DeviceType,
      interface: Interface,
      inventory_item: InventoryItem,
      manufacturer: Manufacturer,
      platform: Platform,
      power_outlet: PowerOutlet,
      power_port: PowerPort,
      rack: Rack,
      rack_group: RackGroup,
      rack_role: RackRole,
      region: Region,
      site: Site
    }.each_pair do |method_name, class_name|
      define_method(method_name) { |id| class_name.new id }
      module_function(method_name)
    end
  end
end
