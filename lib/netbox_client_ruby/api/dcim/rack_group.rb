# frozen_string_literal: true

module NetboxClientRuby
  module DCIM
    class RackGroup
      include Entity

      id id: :id
      deletable true
      path 'dcim/rack-groups/:id/'
      creation_path 'dcim/rack-groups/'
      object_fields(
        region: proc { |raw_data| DCIM::Region.new raw_data['id'] },
        tenant: proc { |raw_data| Tenancy::Tenant.new raw_data['id'] },
      )
    end
  end
end
