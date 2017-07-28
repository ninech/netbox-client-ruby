require 'netbox_client_ruby/entities'
require 'netbox_client_ruby/api/tenancy/tenant'

module NetboxClientRuby
  module Tenancy
    class Tenants
      include Entities

      path 'tenancy/tenants.json'
      data_key 'results'
      count_key 'count'
      entity_creator :entity_creator

      private

      def entity_creator(raw_entity)
        Tenant.new raw_entity['id']
      end
    end
  end
end
