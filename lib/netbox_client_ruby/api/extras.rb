require 'netbox_client_ruby/api/extras/tag'
require 'netbox_client_ruby/api/extras/tags'

module NetboxClientRuby
  module Extras
    {
      tags: Tags
    }.each_pair do |method_name, class_name|
      define_method(method_name) { class_name.new }
      module_function(method_name)
    end

    {
      tag: Tag
    }.each_pair do |method_name, class_name|
      define_method(method_name) { |id| class_name.new id }
      module_function(method_name)
    end
  end
end
