require 'netbox_client_ruby/api/dcim/console_connection'
require 'netbox_client_ruby/api/dcim/console_connections'
require 'netbox_client_ruby/api/dcim/console_port'
require 'netbox_client_ruby/api/dcim/console_ports'
require 'netbox_client_ruby/api/dcim/console_server_port'
require 'netbox_client_ruby/api/dcim/console_server_ports'
require 'netbox_client_ruby/api/dcim/device'
require 'netbox_client_ruby/api/dcim/devices'
require 'netbox_client_ruby/api/dcim/device_role'
require 'netbox_client_ruby/api/dcim/device_roles'
require 'netbox_client_ruby/api/dcim/device_type'
require 'netbox_client_ruby/api/dcim/device_types'
require 'netbox_client_ruby/api/dcim/interface'
require 'netbox_client_ruby/api/dcim/interface_connection'
require 'netbox_client_ruby/api/dcim/interface_connections'
require 'netbox_client_ruby/api/dcim/interfaces'
require 'netbox_client_ruby/api/dcim/inventory_item'
require 'netbox_client_ruby/api/dcim/inventory_items'
require 'netbox_client_ruby/api/dcim/manufacturer'
require 'netbox_client_ruby/api/dcim/manufacturers'
require 'netbox_client_ruby/api/dcim/platform'
require 'netbox_client_ruby/api/dcim/platforms'
require 'netbox_client_ruby/api/dcim/power_connection'
require 'netbox_client_ruby/api/dcim/power_connections'
require 'netbox_client_ruby/api/dcim/power_outlet'
require 'netbox_client_ruby/api/dcim/power_outlets'
require 'netbox_client_ruby/api/dcim/power_port'
require 'netbox_client_ruby/api/dcim/power_ports'
require 'netbox_client_ruby/api/dcim/rack'
require 'netbox_client_ruby/api/dcim/rack_group'
require 'netbox_client_ruby/api/dcim/rack_groups'
require 'netbox_client_ruby/api/dcim/rack_reservation'
require 'netbox_client_ruby/api/dcim/rack_reservations'
require 'netbox_client_ruby/api/dcim/rack_role'
require 'netbox_client_ruby/api/dcim/rack_roles'
require 'netbox_client_ruby/api/dcim/racks'
require 'netbox_client_ruby/api/dcim/region'
require 'netbox_client_ruby/api/dcim/regions'
require 'netbox_client_ruby/api/dcim/site'
require 'netbox_client_ruby/api/dcim/sites'
require 'netbox_client_ruby/api/dcim/virtual_chassis'
require 'netbox_client_ruby/api/dcim/virtual_chassis_list'
require 'netbox_client_ruby/communication'

module NetboxClientRuby
  module DCIM
    {
      console_connections: ConsoleConnections,
      console_ports: ConsolePorts,
      console_server_ports: ConsoleServerPorts,
      devices: Devices,
      device_roles: DeviceRoles,
      device_types: DeviceTypes,
      interfaces: Interfaces,
      interface_connections: InterfaceConnections,
      inventory_items: InventoryItems,
      manufacturers: Manufacturers,
      platforms: Platforms,
      power_connections: PowerConnections,
      power_outlets: PowerOutlets,
      power_ports: PowerPorts,
      racks: Racks,
      rack_groups: RackGroups,
      rack_reservations: RackReservations,
      rack_roles: RackRoles,
      regions: Regions,
      sites: Sites,
      virtual_chassis_list: VirtualChassisList
    }.each_pair do |method_name, class_name|
      define_method(method_name) { class_name.new }
      module_function(method_name)
    end

    {
      console_connection: ConsoleConnection,
      console_port: ConsolePort,
      console_server_port: ConsoleServerPort,
      device: Device,
      device_role: DeviceRole,
      device_type: DeviceType,
      interface: Interface,
      interface_connection: InterfaceConnection,
      inventory_item: InventoryItem,
      manufacturer: Manufacturer,
      platform: Platform,
      power_connection: PowerConnection,
      power_outlet: PowerOutlet,
      power_port: PowerPort,
      rack: Rack,
      rack_group: RackGroup,
      rack_reservation: RackReservation,
      rack_role: RackRole,
      region: Region,
      site: Site,
      virtual_chassis: VirtualChassis
    }.each_pair do |method_name, class_name|
      define_method(method_name) { |id| class_name.new id }
      module_function(method_name)
    end
  end
end
