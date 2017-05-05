require 'netbox_client_ruby/entity'

module NetboxClientRuby
  class Platform
    include NetboxClientRuby::Entity

    id id: :id
    deletable true
    path 'dcim/platforms/:id.json'
    creation_path 'dcim/platforms/'

  end
end
