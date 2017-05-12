require 'netbox_client_ruby/entity'
require 'netbox_client_ruby/api/dcim/interface'
require 'netbox_client_ruby/api/ipam/vrf'
require 'netbox_client_ruby/api/tenancy/tenant'

module NetboxClientRuby
  class IpAddress
    include NetboxClientRuby::Entity

    STATUS_VALUES = {
      active: 1,
      reserved: 2,
      deprecated: 3,
      dhcp: 5
    }.freeze

    id id: :id
    deletable true
    path 'ipam/ip-addresses/:id.json'
    creation_path 'ipam/ip-addresses/'
    object_fields(
      vrf: proc { |raw_data| NetboxClientRuby::Vrf.new raw_data['id'] },
      tenant: proc { |raw_data| NetboxClientRuby::Tenant.new raw_data['id'] },
      status: proc { |raw_data| STATUS_VALUES.key(raw_data['value']) || raw_data['value'] },
      interface: proc { |raw_data| NetboxClientRuby::Interface.new raw_data['id'] }
    )
    readonly_fields :display_name

    def status=(value)
      status_code_lookup = STATUS_VALUES.fetch(value, value)
      method_missing(:status=, status_code_lookup)
    end
  end
end
