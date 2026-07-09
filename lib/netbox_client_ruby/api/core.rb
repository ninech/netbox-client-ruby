# frozen_string_literal: true

module NetboxClientRuby
  module Core
    {
      object_changes: ObjectChanges,
    }.each_pair do |method_name, class_name|
      NetboxClientRuby.load_collection(self, method_name, class_name)
    end

    {
      object_change: ObjectChange,
    }.each_pair do |method_name, class_name|
      NetboxClientRuby.load_entity(self, method_name, class_name)
    end
  end
end
