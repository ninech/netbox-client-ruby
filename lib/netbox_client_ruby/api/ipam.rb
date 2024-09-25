# frozen_string_literal: true

require 'netbox_client_ruby/api/ipam/aggregate'
require 'netbox_client_ruby/api/ipam/aggregates'
require 'netbox_client_ruby/api/ipam/ip_addresses'
require 'netbox_client_ruby/api/ipam/ip_address'
require 'netbox_client_ruby/api/ipam/ip_ranges'
require 'netbox_client_ruby/api/ipam/ip_range'
require 'netbox_client_ruby/api/ipam/prefix'
require 'netbox_client_ruby/api/ipam/prefixes'
require 'netbox_client_ruby/api/ipam/rir'
require 'netbox_client_ruby/api/ipam/rirs'
require 'netbox_client_ruby/api/ipam/role'
require 'netbox_client_ruby/api/ipam/roles'
require 'netbox_client_ruby/api/ipam/service'
require 'netbox_client_ruby/api/ipam/services'
require 'netbox_client_ruby/api/ipam/vlan_group'
require 'netbox_client_ruby/api/ipam/vlan_groups'
require 'netbox_client_ruby/api/ipam/vlan'
require 'netbox_client_ruby/api/ipam/vlans'
require 'netbox_client_ruby/api/ipam/vrf'
require 'netbox_client_ruby/api/ipam/vrfs'
require 'netbox_client_ruby/communication'

module NetboxClientRuby
  module IPAM
    {
      aggregates: Aggregates,
      ip_addresses: IpAddresses,
      ip_ranges: IpRanges,
      prefixes: Prefixes,
      rirs: Rirs,
      roles: Roles,
      services: Services,
      vlans: Vlans,
      vlan_groups: VlanGroups,
      vrfs: Vrfs,
    }.each_pair do |method_name, class_name|
      define_method(method_name) { class_name.new }
      module_function(method_name)
    end

    {
      aggregate: Aggregate,
      ip_address: IpAddress,
      ip_range: IpRange,
      prefix: Prefix,
      rir: Rir,
      role: Role,
      service: Service,
      vlan: Vlan,
      vlan_group: VlanGroup,
      vrf: Vrf,
    }.each_pair do |method_name, class_name|
      define_method(method_name) { |id| class_name.new id }
      module_function(method_name)
    end
  end
end
