require 'netbox_client_ruby/entities'
require 'netbox_client_ruby/api/secrets/secret'

module NetboxClientRuby
  module Secrets
    class Secrets
      include Entities

      path 'secrets/secrets.json'
      data_key 'results'
      count_key 'count'
      entity_creator :entity_creator

      private

      def entity_creator(raw_entity)
        Secret.new raw_entity['id']
      end
    end
  end
end
