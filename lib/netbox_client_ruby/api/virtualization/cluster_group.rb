require 'netbox_client_ruby/entity'

module NetboxClientRuby
  module Virtualization
    class ClusterGroup
      include Entity

      id id: :id
      deletable true
      path 'virtualization/cluster-groups/:id.json'
      creation_path 'virtualization/cluster-groups/'
    end
  end
end
