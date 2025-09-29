# frozen_string_literal: true

module NetboxClientRuby
  module Extras
    {
      config_contexts: ConfigContexts,
      journal_entries: JournalEntries,
      tags: Tags,
    }.each_pair do |method_name, class_name|
      NetboxClientRuby.load_collection(self, method_name, class_name)
    end

    {
      config_context: ConfigContext,
      journal_entry: JournalEntry,
      tag: Tag,
    }.each_pair do |method_name, class_name|
      NetboxClientRuby.load_entity(self, method_name, class_name)
    end
  end
end
