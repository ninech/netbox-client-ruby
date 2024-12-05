# frozen_string_literal: true

module NetboxClientRuby
  module IPAM
    class Asn
      include Entity

      id id: :id
      deletable true
      path 'ipam/asns/:id/'
      creation_path 'ipam/asns/'
      object_fields(
        tenant: proc { |raw_data| Tenancy::Tenant.new raw_data['id'] }
      )
    end

  end
end
