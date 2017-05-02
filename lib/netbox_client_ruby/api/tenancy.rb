require 'netbox_client_ruby/api/tenancy/tenant'
require 'netbox_client_ruby/api/tenancy/tenants'
require 'netbox_client_ruby/api/tenancy/tenant_group'
require 'netbox_client_ruby/api/tenancy/tenant_groups'
require 'netbox_client_ruby/communication'

module NetboxClientRuby
  class Tenancy
    def tenants
      Tenants.new
    end

    def tenant(id)
      Tenant.new id
    end

    def tenant_groups
      TenantGroups.new
    end

    def tenant_group
      TenantGroup.new
    end
  end
end
