require 'netbox_client_ruby/entity'

module NetboxClientRuby
  class Role
    include NetboxClientRuby::Entity

    id id: :id
    deletable true
    path 'ipam/roles/:id.json'
    creation_path 'ipam/roles/'
  end
end
