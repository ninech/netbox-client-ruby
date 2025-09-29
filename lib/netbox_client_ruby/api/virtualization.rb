# frozen_string_literal: true

module NetboxClientRuby
  module Virtualization
    {
      cluster_groups: ClusterGroups,
      cluster_types: ClusterTypes,
      clusters: Clusters,
      virtual_machines: VirtualMachines,
      interfaces: Interfaces,
    }.each_pair do |method_name, class_name|
      NetboxClientRuby.load_collection(self, method_name, class_name)
    end

    {
      cluster_group: ClusterGroup,
      cluster_type: ClusterType,
      cluster: Cluster,
      virtual_machine: VirtualMachine,
      interface: Interface,
    }.each_pair do |method_name, class_name|
      NetboxClientRuby.load_entity(self, method_name, class_name)
    end
  end
end
