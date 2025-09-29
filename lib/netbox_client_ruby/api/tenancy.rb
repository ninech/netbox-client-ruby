# frozen_string_literal: true

module NetboxClientRuby
  module Tenancy
    {
      tenants: Tenants,
      tenant_groups: TenantGroups,
      contacts: Contacts,
      contact_groups: ContactGroups,
    }.each_pair do |method_name, class_name|
      NetboxClientRuby.load_collection(self, method_name, class_name)
    end

    {
      tenant: Tenant,
      tenant_group: TenantGroup,
      contact: Contact,
      contact_group: ContactGroup,
    }.each_pair do |method_name, class_name|
      NetboxClientRuby.load_entity(self, method_name, class_name)
    end
  end
end
