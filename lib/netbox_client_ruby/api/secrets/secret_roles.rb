require 'netbox_client_ruby/entities'
require 'netbox_client_ruby/api/secrets/secret_role'

module NetboxClientRuby
  module Secrets
    class SecretRoles
      include Entities

      path 'secrets/secret-roles.json'
      data_key 'results'
      count_key 'count'
      entity_creator :entity_creator

      private

      def entity_creator(raw_entity)
        SecretRole.new raw_entity['id']
      end
    end
  end
end
