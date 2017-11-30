require 'netbox_client_ruby/entity'

module NetboxClientRuby
  module Virtualization
    class ClusterType
      include Entity

      id id: :id
      deletable true
      path 'virtualization/cluster-types/:id.json'
      creation_path 'virtualization/cluster-types/'
    end
  end
end
