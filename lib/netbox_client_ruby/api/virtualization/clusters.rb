require 'netbox_client_ruby/entities'
require 'netbox_client_ruby/api/virtualization/cluster'

module NetboxClientRuby
  module Virtualization
    class Clusters
      include Entities

      path 'virtualization/clusters.json'
      data_key 'results'
      count_key 'count'
      entity_creator :entity_creator

      private

      def entity_creator(raw_entity)
        Cluster.new raw_entity['id']
      end
    end
  end
end
