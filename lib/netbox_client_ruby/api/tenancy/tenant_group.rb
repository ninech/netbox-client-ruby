# frozen_string_literal: true

module NetboxClientRuby
  module Tenancy
    class TenantGroup
      include Entity

      id id: :id
      deletable true
      path 'tenancy/tenant-groups/:id/'
      creation_path 'tenancy/tenant-groups/'
    end
  end
end
