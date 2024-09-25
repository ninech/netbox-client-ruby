# frozen_string_literal: true

require 'spec_helper'

RSpec.describe NetboxClientRuby::Virtualization do
  {
    cluster_groups: NetboxClientRuby::Virtualization::ClusterGroups,
    cluster_types: NetboxClientRuby::Virtualization::ClusterTypes,
    clusters: NetboxClientRuby::Virtualization::Clusters,
    virtual_machines: NetboxClientRuby::Virtualization::VirtualMachines,
    interfaces: NetboxClientRuby::Virtualization::Interfaces,
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
    cluster_group: NetboxClientRuby::Virtualization::ClusterGroup,
    cluster_type: NetboxClientRuby::Virtualization::ClusterType,
    cluster: NetboxClientRuby::Virtualization::Cluster,
    virtual_machine: NetboxClientRuby::Virtualization::VirtualMachine,
    interface: NetboxClientRuby::Virtualization::Interface,
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
