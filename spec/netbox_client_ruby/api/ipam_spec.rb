require 'spec_helper'

describe NetboxClientRuby::IPAM do
  let(:sut) { NetboxClientRuby::IPAM }

  {
    roles: NetboxClientRuby::Roles,
    ip_addresses: NetboxClientRuby::IpAddresses,
    vlan_groups: NetboxClientRuby::VlanGroups,
    vrfs: NetboxClientRuby::Vrfs,
    vlans: NetboxClientRuby::Vlans,
    rirs: NetboxClientRuby::Rirs,
    prefixes: NetboxClientRuby::Prefixes
  }.each do |method, klass|
    describe ".#{method}" do
      subject { sut.new.public_send(method) }

      context 'is of the correct type' do
        it { is_expected.to be_a klass }
      end

      context 'is a different instance each time' do
        it do
          is_expected
            .to_not be sut.new.public_send(method)
        end
      end

      context 'is an Entities object' do
        it { is_expected.to respond_to(:get!) }
      end
    end
  end

  {
    role: NetboxClientRuby::Role,
    ip_address: NetboxClientRuby::IpAddress,
    vlan_group: NetboxClientRuby::VlanGroup,
    vrf: NetboxClientRuby::Vrf,
    vlan: NetboxClientRuby::Vlan,
    rir: NetboxClientRuby::Rir,
    prefix: NetboxClientRuby::Prefix
  }.each do |method, expected_class|
    describe ".#{method}" do
      let(:id) { 1 }
      subject { sut.new.public_send(method, id) }

      context 'is of the expected type' do
        it { is_expected.to be_a expected_class }
      end

      context 'it is a new instance each time' do
        it do
          is_expected
            .to_not be sut.new.public_send(method, id)
        end
      end

      context 'is an Entity object' do
        it { is_expected.to respond_to(:get!) }
      end
    end
  end
end
