require 'netbox_client_ruby/entity'
require 'netbox_client_ruby/api/dcim/device'
require 'netbox_client_ruby/api/secrets/secret_role'

module NetboxClientRuby
  module Secrets
    class SecretRole
      include Entity

      id id: :id
      deletable true
      path 'secrets/secret-roles/:id.json'
      creation_path 'secrets/secret-roles/'
    end
  end
end
