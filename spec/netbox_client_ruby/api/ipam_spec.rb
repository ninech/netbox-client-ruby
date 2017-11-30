require 'spec_helper'

module NetboxClientRuby
  module IPAM
    describe IPAM do
      {
        roles: Roles,
        ip_addresses: IpAddresses,
        vlan_groups: VlanGroups,
        vrfs: Vrfs,
        vlans: Vlans,
        rirs: Rirs,
        prefixes: Prefixes
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
        role: Role,
        ip_address: IpAddress,
        vlan_group: VlanGroup,
        vrf: Vrf,
        vlan: Vlan,
        rir: Rir,
        prefix: Prefix
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

