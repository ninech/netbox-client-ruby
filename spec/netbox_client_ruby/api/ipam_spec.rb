# frozen_string_literal: true

require 'spec_helper'

RSpec.describe NetboxClientRuby::IPAM do
  {
    roles: NetboxClientRuby::IPAM::Roles,
    ip_addresses: NetboxClientRuby::IPAM::IpAddresses,
    ip_ranges: NetboxClientRuby::IPAM::IpRanges,
    vlan_groups: NetboxClientRuby::IPAM::VlanGroups,
    vrfs: NetboxClientRuby::IPAM::Vrfs,
    vlans: NetboxClientRuby::IPAM::Vlans,
    rirs: NetboxClientRuby::IPAM::Rirs,
    prefixes: NetboxClientRuby::IPAM::Prefixes
  }.each do |method, klass|
    describe ".#{method}" do
      subject { described_class.public_send(method) }

      context 'is of the correct type' do
        it { is_expected.to be_a klass }
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
    role: NetboxClientRuby::IPAM::Role,
    ip_address: NetboxClientRuby::IPAM::IpAddress,
    ip_range: NetboxClientRuby::IPAM::IpRange,
    vlan_group: NetboxClientRuby::IPAM::VlanGroup,
    vrf: NetboxClientRuby::IPAM::Vrf,
    vlan: NetboxClientRuby::IPAM::Vlan,
    rir: NetboxClientRuby::IPAM::Rir,
    prefix: NetboxClientRuby::IPAM::Prefix
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
