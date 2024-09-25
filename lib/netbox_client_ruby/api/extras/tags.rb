# frozen_string_literal: true

require 'netbox_client_ruby/entities'
require 'netbox_client_ruby/api/extras/tag'

module NetboxClientRuby
  module Extras
    class Tags
      include Entities

      path 'extras/tags/'
      data_key 'results'
      count_key 'count'
      entity_creator :entity_creator

      private

      def entity_creator(raw_entity)
        Tag.new raw_entity['id']
      end
    end
  end
end
