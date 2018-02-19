require 'netbox_client_ruby/entity'
require 'netbox_client_ruby/api/dcim/region'
require 'netbox_client_ruby/api/tenancy/tenant'

module NetboxClientRuby
  module DCIM
    class RackRole
      include Entity

      id id: :id
      deletable true
      path 'dcim/rack-roles/:id.json'
      creation_path 'dcim/rack-roles/'
    end
  end
end
