require 'spec_helper'

module NetboxClientRuby
  module DCIM
    describe DCIM do
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
        regions: Regions,
        sites: Sites
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
        region: Region,
        site: Site
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
