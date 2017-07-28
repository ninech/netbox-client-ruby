require 'netbox_client_ruby/entities'
require 'netbox_client_ruby/api/dcim/region'

module NetboxClientRuby
  module DCIM
    class Regions
      include Entities

      path 'dcim/regions.json'
      data_key 'results'
      count_key 'count'
      entity_creator :entity_creator

      private

      def entity_creator(raw_entity)
        Region.new raw_entity['id']
      end
    end
  end
end
