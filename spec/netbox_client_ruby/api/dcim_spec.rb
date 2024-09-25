# frozen_string_literal: true

require 'spec_helper'

module NetboxClientRuby
  module DCIM
    RSpec.describe DCIM do
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
      }.each do |method, expected_class|
        describe ".#{method}" do
          subject { described_class.public_send(method) }

          context 'is of the correct type' do
            it { is_expected.to be_a expected_class }
          end

          context 'is a different instance each time' do
            it do
              is_expected
                .to_not be described_class.public_send(method)
            end
          end

          context 'is an Entities object' do
            it { is_expected.to respond_to(:get!) }
          end
        end
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
      }.each do |method, expected_class|
        describe ".#{method}" do
          let(:id) { 1 }
          subject { described_class.public_send(method, id) }

          context 'is of the expected type' do
            it { is_expected.to be_a expected_class }
          end

          context 'it is a new instance each time' do
            it do
              is_expected
                .to_not be described_class.public_send(method, id)
            end
          end

          context 'is an Entity object' do
            it { is_expected.to respond_to(:get!) }
          end
        end
      end
    end
  end
end
