require 'netbox_client_ruby/entities'
require 'netbox_client_ruby/api/virtualization/cluster_type'

module NetboxClientRuby
  module Virtualization
    class ClusterTypes
      include Entities

      path 'virtualization/cluster-types.json'
      data_key 'results'
      count_key 'count'
      entity_creator :entity_creator

      private

      def entity_creator(raw_entity)
        ClusterType.new raw_entity['id']
      end
    end
  end
end
