require 'netbox_client_ruby/entities'
require 'netbox_client_ruby/api/dcim/interface'

module NetboxClientRuby
  module DCIM
    class Interfaces
      include Entities

      path 'dcim/interfaces.json'
      data_key 'results'
      count_key 'count'
      entity_creator :entity_creator

      private

      def entity_creator(raw_entity)
        Interface.new raw_entity['id']
      end
    end
  end
end
