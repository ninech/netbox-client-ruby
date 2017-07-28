require 'netbox_client_ruby/entity'

module NetboxClientRuby
  module DCIM
    class Platform
      include Entity

      id id: :id
      deletable true
      path 'dcim/platforms/:id.json'
      creation_path 'dcim/platforms/'
    end
  end
end
