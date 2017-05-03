require 'netbox_client_ruby/entity'
require 'netbox_client_ruby/api/tenancy/tenant'

module NetboxClientRuby
  class Rir
    include NetboxClientRuby::Entity

    id id: :id
    deletable true
    path 'ipam/rirs/:id.json'
    creation_path 'ipam/rirs/'

  end
end
