# frozen_string_literal: true

module NetboxClientRuby
  module Tenancy
    class TenantGroups
      include Entities

      path 'tenancy/tenant-groups/'
      data_key 'results'
      count_key 'count'
      entity_creator :entity_creator

      private

      def entity_creator(raw_entity)
        TenantGroup.new raw_entity['id']
      end
    end
  end
end
