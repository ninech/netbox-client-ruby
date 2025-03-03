# frozen_string_literal: true

module NetboxClientRuby
  module Tenancy
    class Contacts
      include Entities

      path 'tenancy/contacts/'
      data_key 'results'
      count_key 'count'
      entity_creator :entity_creator

      private

      def entity_creator(raw_entity)
        Contact.new raw_entity['id']
      end
    end
  end
end
