# frozen_string_literal: true

module NetboxClientRuby
  module IPAM
    class Vrf
      include Entity

      id id: :id
      deletable true
      path 'ipam/vrfs/:id/'
      creation_path 'ipam/vrfs/'
      object_fields tenant: proc { |raw_data| Tenancy::Tenant.new raw_data['id'] }
    end
  end
end
