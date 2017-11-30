require 'netbox_client_ruby/api/virtualization/cluster_group'
require 'netbox_client_ruby/api/virtualization/cluster_groups'
require 'netbox_client_ruby/api/virtualization/cluster_type'
require 'netbox_client_ruby/api/virtualization/cluster_types'
require 'netbox_client_ruby/api/virtualization/cluster'
require 'netbox_client_ruby/api/virtualization/clusters'
require 'netbox_client_ruby/api/virtualization/interface'
require 'netbox_client_ruby/api/virtualization/interfaces'
require 'netbox_client_ruby/api/virtualization/virtual_machine'
require 'netbox_client_ruby/api/virtualization/virtual_machines'
require 'netbox_client_ruby/communication'

module NetboxClientRuby
  module Virtualization
    {
      cluster_groups: ClusterGroups,
      cluster_types: ClusterTypes,
      clusters: Clusters,
      virtual_machines: VirtualMachines,
      interfaces: Interfaces,
    }.each_pair do |method_name, class_name|
      define_method(method_name) { class_name.new }
      module_function(method_name)
    end

    {
      cluster_group: ClusterGroup,
      cluster_type: ClusterType,
      cluster: Cluster,
      virtual_machine: VirtualMachine,
      interface: Interface,
    }.each_pair do |method_name, class_name|
      define_method(method_name) { |id| class_name.new id }
      module_function(method_name)
    end
  end
end
