# frozen_string_literal: true

module NetboxClientRuby
  module IPAM
    class Rirs
      include Entities

      path 'ipam/rirs/'
      data_key 'results'
      count_key 'count'
      entity_creator :entity_creator

      private

      def entity_creator(raw_entity)
        Rir.new raw_entity['id']
      end
    end
  end
end
