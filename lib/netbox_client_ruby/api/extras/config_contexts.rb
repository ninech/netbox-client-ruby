require 'netbox_client_ruby/entities'
require 'netbox_client_ruby/api/extras/config_context'

module NetboxClientRuby
  module Extras
    class ConfigContexts
      include Entities

      path 'extras/config-contexts/'
      data_key 'results'
      count_key 'count'
      entity_creator :entity_creator

      private

      def entity_creator(raw_entity)
        ConfigContext.new raw_entity['id']
      end
    end
  end
end
