require 'netbox_client_ruby/entity'

module NetboxClientRuby
  module Tenancy
    class TenantGroup
      include Entity

      id id: :id
      deletable true
      path 'tenancy/tenant-groups/:id.json'
      creation_path 'tenancy/tenant-groups/'
    end
  end
end
