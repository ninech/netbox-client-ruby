require 'netbox_client_ruby/entity'

module NetboxClientRuby
  class Manufacturer
    include NetboxClientRuby::Entity

    id id: :id
    deletable true
    path 'dcim/manufacturers/:id.json'
    creation_path 'dcim/manufacturers/'

  end
end
