# frozen_string_literal: true

module NetboxClientRuby
  module Extras
    {
      config_contexts: ConfigContexts,
      journal_entries: JournalEntries,
      tags: Tags
    }.each_pair do |method_name, class_name|
      define_method(method_name) { class_name.new }
      module_function(method_name)
    end

    {
      config_context: ConfigContext,
      journal_entry: JournalEntry,
      tag: Tag
    }.each_pair do |method_name, class_name|
      define_method(method_name) { |id| class_name.new id }
      module_function(method_name)
    end
  end
end
