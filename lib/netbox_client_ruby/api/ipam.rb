# frozen_string_literal: true

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
      asns: Asns
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
      asn: Asn
    }.each_pair do |method_name, class_name|
      define_method(method_name) { |id| class_name.new id }
      module_function(method_name)
    end
  end
end
