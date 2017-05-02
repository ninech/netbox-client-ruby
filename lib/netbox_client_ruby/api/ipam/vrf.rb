require 'netbox_client_ruby/entity'
require 'netbox_client_ruby/api/tenancy/tenant'

module NetboxClientRuby
  class Vrf
    include NetboxClientRuby::Entity

    id id: :id
    deletable true
    path 'ipam/vrfs/:id.json'
    creation_path 'ipam/vrfs/'
    object_fields tenant: proc { |raw_data| NetboxClientRuby::Tenant.new raw_data['id'] }

  end
end
