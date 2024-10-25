# frozen_string_literal: true

module NetboxClientRuby
  module Virtualization
    class Cluster
      include Entity

      id id: :id
      deletable true
      path 'virtualization/clusters/:id.json'
      creation_path 'virtualization/clusters/'
      object_fields(
        group: proc { |raw_data| ClusterGroup.new raw_data['id'] },
        site: proc { |raw_data| DCIM::Site.new raw_data['id'] },
        type: proc { |raw_data| ClusterType.new raw_data['id'] },
      )
    end
  end
end
