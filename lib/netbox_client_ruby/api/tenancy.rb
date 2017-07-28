require 'netbox_client_ruby/api/tenancy/tenant'
require 'netbox_client_ruby/api/tenancy/tenants'
require 'netbox_client_ruby/api/tenancy/tenant_group'
require 'netbox_client_ruby/api/tenancy/tenant_groups'
require 'netbox_client_ruby/communication'

module NetboxClientRuby
  module Tenancy
    {
      tenants: Tenants,
      tenant_groups: TenantGroups
    }.each_pair do |method_name, class_name|
      define_method(method_name) { class_name.new }
      module_function(method_name)
    end

    {
      tenant: Tenant,
      tenant_group: TenantGroup
    }.each_pair do |method_name, class_name|
      define_method(method_name) { |id| class_name.new id }
      module_function(method_name)
    end
  end
end
