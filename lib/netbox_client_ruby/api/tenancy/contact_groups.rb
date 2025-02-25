# frozen_string_literal: true

module NetboxClientRuby
  module Tenancy
    class ContactGroups
      include Entities

      path 'tenancy/contact-groups/'
      data_key 'results'
      count_key 'count'
      entity_creator :entity_creator

      private

      def entity_creator(raw_entity)
        ContactGroup.new raw_entity['id']
      end
    end
  end
end
