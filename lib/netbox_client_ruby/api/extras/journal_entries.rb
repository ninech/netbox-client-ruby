# frozen_string_literal: true

module NetboxClientRuby
  module Extras
    class JournalEntries
      include Entities

      path 'extras/journal-entries/'
      data_key 'results'
      count_key 'count'
      entity_creator :entity_creator

      private

      def entity_creator(raw_entity)
        JournalEntry.new raw_entity['id']
      end
    end
  end
end
