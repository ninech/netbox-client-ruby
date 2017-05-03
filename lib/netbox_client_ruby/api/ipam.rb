require 'netbox_client_ruby/api/ipam/aggregate'
require 'netbox_client_ruby/api/ipam/aggregates'
require 'netbox_client_ruby/api/ipam/ip_addresses'
require 'netbox_client_ruby/api/ipam/ip_address'
require 'netbox_client_ruby/api/ipam/prefix'
require 'netbox_client_ruby/api/ipam/prefixes'
require 'netbox_client_ruby/api/ipam/rir'
require 'netbox_client_ruby/api/ipam/rirs'
require 'netbox_client_ruby/api/ipam/role'
require 'netbox_client_ruby/api/ipam/roles'
# require 'netbox_client_ruby/api/ipam/service'
# require 'netbox_client_ruby/api/ipam/services'
require 'netbox_client_ruby/api/ipam/vlan_group'
require 'netbox_client_ruby/api/ipam/vlan_groups'
require 'netbox_client_ruby/api/ipam/vlan'
require 'netbox_client_ruby/api/ipam/vlans'
require 'netbox_client_ruby/api/ipam/vrf'
require 'netbox_client_ruby/api/ipam/vrfs'
require 'netbox_client_ruby/communication'

module NetboxClientRuby
  class IPAM
    def aggregates
      Aggregates.new
    end

    def aggregate(id)
      Aggregate.new id
    end

    def ip_addresses
      IpAddresses.new
    end

    def ip_address(id)
      IpAddress.new id
    end

    def prefixes
      Prefixes.new
    end

    def prefix
      Prefix.new
    end

    def rirs
      Rirs.new
    end

    def rir(id)
      Rir.new id
    end

    def roles
      Roles.new
    end

    def role(id)
      Role.new id
    end

    def vlans
      Vlans.new
    end

    def vlan(id)
      Vlan.new id
    end

    def vlan_groups
      VlanGroups.new
    end

    def vlan_group(id)
      VlanGroup.new id
    end

    def vrfs
      Vrfs.new
    end

    def vrf(id)
      Vrf.new id
    end
  end
end
