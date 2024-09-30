# frozen_string_literal: true

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
