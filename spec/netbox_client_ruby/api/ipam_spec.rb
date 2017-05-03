require 'spec_helper'

describe NetboxClientRuby::IPAM do
  {
    roles: NetboxClientRuby::Roles,
    vlan_groups: NetboxClientRuby::VlanGroups,
    vrfs: NetboxClientRuby::Vrfs,
    vlans: NetboxClientRuby::Vlans,
    rirs: NetboxClientRuby::Rirs,
    prefixes: NetboxClientRuby::Prefixes
  }.each do |method, klass|
    describe ".#{method}" do
      subject { NetboxClientRuby::IPAM.new.public_send(method) }

      context 'is of the correct type' do
        it { is_expected.to be_a klass }
      end

      context 'is a different instance each time' do
        it do
          is_expected
            .to_not be NetboxClientRuby::IPAM.new.public_send(method)
        end
      end

      context 'is an Entities object' do
        it { is_expected.to respond_to(:get!) }
      end
    end
  end
end
