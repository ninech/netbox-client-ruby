require 'netbox_client_ruby/entities'
require 'netbox_client_ruby/api/dcim/platform'

module NetboxClientRuby
  module DCIM
    class Platforms
      include Entities

      path 'dcim/platforms.json'
      data_key 'results'
      count_key 'count'
      entity_creator :entity_creator

      private

      def entity_creator(raw_entity)
        Platform.new raw_entity['id']
      end
    end
  end
end
