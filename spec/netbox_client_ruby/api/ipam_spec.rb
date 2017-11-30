require 'spec_helper'


module NetboxClientRuby
  module IPAM
    describe IPAM do
      {
        cluster_types: ClusterTypes,
        cluster_groups: ClusterGroups,
        clusters: Clusters,
        virtual_machines: VirtualMachines,
        interfaces: Interfaces,
      }.each do |method, klass|
        describe ".#{method}" do
          subject { IPAM.public_send(method) }

          context 'is of the correct type' do
            it { is_expected.to be_a klass }
          end

          context 'is a different instance each time' do
            it do
              is_expected
                .to_not be IPAM.public_send(method)
            end
          end

          context 'is an Entities object' do
            it { is_expected.to respond_to(:get!) }
          end
        end
      end

      {
        cluster_type: ClusterType,
        cluster_group: ClusterGroup,
        cluster: Cluster,
        virtual_machine: VirtualMachine,
        interface: Interface,
      }.each do |method, expected_class|
        describe ".#{method}" do
          let(:id) { 1 }
          subject { IPAM.public_send(method, id) }

          context 'is of the expected type' do
            it { is_expected.to be_a expected_class }
          end

          context 'it is a new instance each time' do
            it do
              is_expected
                .to_not be IPAM.public_send(method, id)
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

