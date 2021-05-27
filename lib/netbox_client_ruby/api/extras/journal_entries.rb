require 'netbox_client_ruby/entities'
require 'netbox_client_ruby/api/extras/journal_entry'

module NetboxClientRuby
  module Extras
    class JournalEntries
      include Entities

      path 'extras/journal-entries.json'
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
