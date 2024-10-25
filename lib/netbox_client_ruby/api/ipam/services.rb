# frozen_string_literal: true

module NetboxClientRuby
  module IPAM
    class Services
      include Entities

      path 'ipam/services/'
      data_key 'results'
      count_key 'count'
      entity_creator :entity_creator

      private

      def entity_creator(raw_entity)
        Service.new raw_entity['id']
      end
    end
  end
end
