require 'netbox_client_ruby/entity'

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
