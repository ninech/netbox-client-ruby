# frozen_string_literal: true

module NetboxClientRuby
  module Extras
    class ConfigContext
      include Entity

      id id: :id
      deletable true
      path 'extras/config-contexts/:id/'
      creation_path 'extras/config-contexts/'
      object_fields(
        regions: proc { |raw_data| DCIM::Region.new raw_data['id'] },
        sites: proc { |raw_data| DCIM::Site.new raw_data['id'] },
        roles: proc { |raw_data| DCIM::DeviceRole.new raw_data['id'] },
        platforms: proc { |raw_data| DCIM::Platform.new raw_data['id'] },
        cluster_groups: proc { |raw_data| Virtualization::ClusterGroup.new raw_data['id'] },
        clusters: proc { |raw_data| Virtualization::Cluster.new raw_data['id'] },
        tenant_groups: proc { |raw_data| Tenancy::TenantGroup.new raw_data['id'] },
        tenants: proc { |raw_data| Tenancy::Tenant.new raw_data['id'] },
        tags: proc { |raw_data| Tag.new raw_data['id'] }
      )
    end
  end
end
