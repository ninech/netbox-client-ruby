require 'netbox_client_ruby/entities'
require 'netbox_client_ruby/api/tenancy/tenant_group'

module NetboxClientRuby
  class TenantGroups
    include NetboxClientRuby::Entities

    path 'tenancy/tenant-groups.json'
    data_key 'results'
    count_key 'count'
    entity_creator :entity_creator

    private

    def entity_creator(raw_entity)
      NetboxClientRuby::TenantGroup.new raw_entity['id']
    end
  end
end
