require 'netbox_client_ruby/entities'
require 'netbox_client_ruby/api/virtualization/cluster_group'

module NetboxClientRuby
  module Virtualization
    class ClusterGroups
      include Entities

      path 'virtualization/cluster-groups.json'
      data_key 'results'
      count_key 'count'
      entity_creator :entity_creator

      private

      def entity_creator(raw_entity)
        ClusterGroup.new raw_entity['id']
      end
    end
  end
end
