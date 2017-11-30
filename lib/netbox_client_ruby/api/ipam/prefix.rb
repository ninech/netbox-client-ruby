require 'netbox_client_ruby/entity'
require 'netbox_client_ruby/api/ipam/role'
require 'netbox_client_ruby/api/dcim/site'
require 'netbox_client_ruby/api/ipam/vrf'
require 'netbox_client_ruby/api/ipam/vlan'
require 'netbox_client_ruby/api/ipam/vlan_group'
require 'netbox_client_ruby/api/tenancy/tenant'
require 'ipaddress'

module NetboxClientRuby
  module IPAM
    class Prefix
      include Entity

      id id: :id
      deletable true
      path 'ipam/prefixes/:id.json'
      creation_path 'ipam/prefixes/'
      object_fields(
        site: proc { |raw_data| DCIM::Site.new raw_data['id'] },
        vrf: proc { |raw_data| Vrf.new raw_data['id'] },
        tenant: proc { |raw_data| Tenancy::Tenant.new raw_data['id'] },
        vlan: proc { |raw_data| Vlan.new raw_data['id'] },
        status: proc { |raw_data| PrefixStatus.new raw_data },
        role: proc { |raw_data| Role.new raw_data['id'] },
        prefix: proc { |raw_data| IPAddress.parse raw_data }
      )
      readonly_fields :display_name
    end

    class PrefixStatus
      attr_reader :value, :label

      def initialize(raw_data)
        @value = raw_data['value']
        @label = raw_data['label']
      end
    end
  end
end
