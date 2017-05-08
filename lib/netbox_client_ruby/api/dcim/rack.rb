require 'netbox_client_ruby/entity'

module NetboxClientRuby
  class Rack
    include NetboxClientRuby::Entity

    id id: :id
    deletable true
    path 'dcim/racks/:id.json'
    creation_path 'dcim/racks/'
  end
end
