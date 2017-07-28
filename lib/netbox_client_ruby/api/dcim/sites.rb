require 'netbox_client_ruby/entities'
require 'netbox_client_ruby/api/dcim/site'

module NetboxClientRuby
  module DCIM
    class Sites
      include Entities

      path 'dcim/sites.json'
      data_key 'results'
      count_key 'count'
      entity_creator :entity_creator

      private

      def entity_creator(raw_entity)
        Site.new raw_entity['id']
      end
    end
  end
end
