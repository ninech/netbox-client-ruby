# frozen_string_literal: true

module NetboxClientRuby
  module Virtualization
    class ClusterType
      include Entity

      id id: :id
      deletable true
      path 'virtualization/cluster-types/:id/'
      creation_path 'virtualization/cluster-types/'
    end
  end
end
