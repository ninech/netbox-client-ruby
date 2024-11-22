# frozen_string_literal: true

module NetboxClientRuby
  module Tenancy
    class Tenant
      include Entity

      id id: :id
      deletable true
      path 'tenancy/tenants/:id/'
      creation_path 'tenancy/tenants/'
      object_fields group: proc { |raw_data| TenantGroup.new raw_data['id'] }
    end
  end
end
