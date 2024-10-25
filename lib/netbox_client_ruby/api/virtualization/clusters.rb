# frozen_string_literal: true

module NetboxClientRuby
  module Virtualization
    class Clusters
      include Entities

      path 'virtualization/clusters/'
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
