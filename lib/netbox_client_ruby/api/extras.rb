require 'netbox_client_ruby/api/extras/journal_entry'
require 'netbox_client_ruby/api/extras/journal_entries'
require 'netbox_client_ruby/api/extras/tag'
require 'netbox_client_ruby/api/extras/tags'

module NetboxClientRuby
  module Extras
    {
      journal_entries: JournalEntries,
      tags: Tags
    }.each_pair do |method_name, class_name|
      define_method(method_name) { class_name.new }
      module_function(method_name)
    end

    {
      journal_entry: JournalEntry,
      tag: Tag
    }.each_pair do |method_name, class_name|
      define_method(method_name) { |id| class_name.new id }
      module_function(method_name)
    end
  end
end
