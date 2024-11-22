# frozen_string_literal: true

module NetboxClientRuby
  module DCIM
    class RackReservation
      include Entity

      id id: :id
      deletable true
      path 'dcim/rack-reservations/:id/'
      creation_path 'dcim/rack-reservations/'

      object_fields(
        rack: proc { |raw_data| DCIM::Rack.new raw_data['id'] },
        tenant: proc { |raw_data| Tenancy::Tenant.new raw_data['id'] },
      )
    end
  end
end
