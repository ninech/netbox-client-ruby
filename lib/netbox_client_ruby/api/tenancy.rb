# frozen_string_literal: true

module NetboxClientRuby
  module Tenancy
    {
      tenants: Tenants,
      tenant_groups: TenantGroups,
      contacts: Contacts,
      contact_groups: ContactGroups
    }.each_pair do |method_name, class_name|
      define_method(method_name) { class_name.new }
      module_function(method_name)
    end

    {
      tenant: Tenant,
      tenant_group: TenantGroup,
      contact: Contact,
      contact_group: ContactGroup
    }.each_pair do |method_name, class_name|
      define_method(method_name) { |id| class_name.new id }
      module_function(method_name)
    end
  end
end
