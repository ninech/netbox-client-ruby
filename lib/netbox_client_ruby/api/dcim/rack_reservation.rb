require 'netbox_client_ruby/entity'
require 'netbox_client_ruby/api/dcim/rack'
require 'netbox_client_ruby/api/tenancy/tenant'

module NetboxClientRuby
  module DCIM
    class RackReservation
      include Entity

      id id: :id
      deletable true
      path 'dcim/rack-reservations/:id.json'
      creation_path 'dcim/rack-reservations/'

      object_fields(
        rack: proc { |raw_data| DCIM::Rack.new raw_data['id'] },
        tenant: proc { |raw_data| Tenancy::Tenant.new raw_data['id'] },
      )
    end
  end
end
