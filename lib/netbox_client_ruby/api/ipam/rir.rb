require 'netbox_client_ruby/entity'

module NetboxClientRuby
  module IPAM
    class Rir
      include Entity

      id id: :id
      deletable true
      path 'ipam/rirs/:id.json'
      creation_path 'ipam/rirs/'
    end
  end
end
