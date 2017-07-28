require 'netbox_client_ruby/entity'
require 'netbox_client_ruby/api/tenancy/tenant'

module NetboxClientRuby
  module IPAM
    class Vrf
      include Entity

      id id: :id
      deletable true
      path 'ipam/vrfs/:id.json'
      creation_path 'ipam/vrfs/'
      object_fields tenant: proc { |raw_data| Tenancy::Tenant.new raw_data['id'] }
    end
  end
end
