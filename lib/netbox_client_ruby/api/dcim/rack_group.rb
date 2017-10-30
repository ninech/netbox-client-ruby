require 'netbox_client_ruby/entity'
require 'netbox_client_ruby/api/dcim/region'
require 'netbox_client_ruby/api/tenancy/tenant'

module NetboxClientRuby
  module DCIM
    class RackGroup
      include Entity

      id id: :id
      deletable true
      path 'dcim/rack-groups/:id.json'
      creation_path 'dcim/rack-groups/'
      object_fields(
        region: proc { |raw_data| DCIM::Region.new raw_data['id'] },
        tenant: proc { |raw_data| Tenancy::Tenant.new raw_data['id'] },
      )
    end
  end
end
