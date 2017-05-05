require 'spec_helper'

describe NetboxClientRuby::DCIM do
  {
    devices: NetboxClientRuby::Devices,
    device_roles: NetboxClientRuby::DeviceRoles,
    device_types: NetboxClientRuby::DeviceTypes,
    interfaces: NetboxClientRuby::Interfaces,
    manufacturers: NetboxClientRuby::Manufacturers,
    platforms: NetboxClientRuby::Platforms,
    racks: NetboxClientRuby::Racks,
    regions: NetboxClientRuby::Regions,
    sites: NetboxClientRuby::Sites,
  }.each do |method, expected_class|
    describe ".#{method}" do
      subject { NetboxClientRuby::DCIM.new.public_send(method) }

      context 'is of the correct type' do
        it { is_expected.to be_a expected_class }
      end

      context 'is a different instance each time' do
        it do
          is_expected
            .to_not be NetboxClientRuby::DCIM.new.public_send(method)
        end
      end

      context 'is an Entities object' do
        it { is_expected.to respond_to(:get!) }
      end
    end
  end

  {
    device: NetboxClientRuby::Device,
    device_role: NetboxClientRuby::DeviceRole,
    device_type: NetboxClientRuby::DeviceType,
    interface: NetboxClientRuby::Interface,
    manufacturer: NetboxClientRuby::Manufacturer,
    platform: NetboxClientRuby::Platform,
    rack: NetboxClientRuby::Rack,
    region: NetboxClientRuby::Region,
    site: NetboxClientRuby::Site,
  }.each do |method, expected_class|
    describe ".#{method}" do
      let(:id) { 1 }
      subject { NetboxClientRuby::DCIM.new.public_send(method, id) }

      context 'is of the expected type' do
        it { is_expected.to be_a expected_class }
      end

      context 'it is a new instance each time' do
        it do
          is_expected
            .to_not be NetboxClientRuby::DCIM.new.public_send(method, id)
        end
      end

      context 'is an Entity object' do
        it { is_expected.to respond_to(:get!) }
      end
    end
  end
end
