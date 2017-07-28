require 'netbox_client_ruby/entity'
require 'netbox_client_ruby/api/tenancy/tenant_group'

module NetboxClientRuby
  module Tenancy
    class Tenant
      include Entity

      id id: :id
      deletable true
      path 'tenancy/tenants/:id.json'
      creation_path 'tenancy/tenants/'
      object_fields group: proc { |raw_data| TenantGroup.new raw_data['id'] }
    end
  end
end
