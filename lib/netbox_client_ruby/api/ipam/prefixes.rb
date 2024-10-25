# frozen_string_literal: true

module NetboxClientRuby
  module IPAM
    class Prefixes
      include Entities

      path 'ipam/prefixes/'
      data_key 'results'
      count_key 'count'
      entity_creator :entity_creator

      private

      def entity_creator(raw_entity)
        Prefix.new raw_entity['id']
      end
    end
  end
end
