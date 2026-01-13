# frozen_string_literal: true

module NetboxClientRuby
  module DCIM
    {
      console_connections: ConsoleConnections,
      console_ports: ConsolePorts,
      console_server_ports: ConsoleServerPorts,
      devices: Devices,
      device_roles: DeviceRoles,
      device_types: DeviceTypes,
      front_ports: FrontPorts,
      interfaces: Interfaces,
      interface_connections: InterfaceConnections,
      inventory_items: InventoryItems,
      locations: Locations,
      mac_addresses: MacAddresses,
      manufacturers: Manufacturers,
      platforms: Platforms,
      power_connections: PowerConnections,
      power_outlets: PowerOutlets,
      power_ports: PowerPorts,
      racks: Racks,
      rack_groups: RackGroups,
      rack_reservations: RackReservations,
      rack_roles: RackRoles,
      rear_ports: RearPorts,
      regions: Regions,
      sites: Sites,
      virtual_chassis_list: VirtualChassisList,
    }.each_pair do |method_name, class_name|
      NetboxClientRuby.load_collection(self, method_name, class_name)
    end

    {
      console_connection: ConsoleConnection,
      console_port: ConsolePort,
      console_server_port: ConsoleServerPort,
      device: Device,
      device_role: DeviceRole,
      device_type: DeviceType,
      front_port: FrontPort,
      interface: Interface,
      interface_connection: InterfaceConnection,
      inventory_item: InventoryItem,
      location: Location,
      mac_address: MacAddress,
      manufacturer: Manufacturer,
      platform: Platform,
      power_connection: PowerConnection,
      power_outlet: PowerOutlet,
      power_port: PowerPort,
      rack: Rack,
      rack_group: RackGroup,
      rack_reservation: RackReservation,
      rack_role: RackRole,
      rear_port: RearPort,
      region: Region,
      site: Site,
      virtual_chassis: VirtualChassis,
    }.each_pair do |method_name, class_name|
      NetboxClientRuby.load_entity(self, method_name, class_name)
    end
  end
end
