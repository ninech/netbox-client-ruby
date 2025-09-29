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
    }.each_pair do |method_name, class_name|
      NetboxClientRuby.load_collection(self, method_name, class_name)
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
      NetboxClientRuby.load_entity(self, method_name, class_name)
    end
  end
end
