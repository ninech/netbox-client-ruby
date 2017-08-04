require 'netbox_client_ruby/api/secrets/secret_roles'
require 'netbox_client_ruby/api/secrets/secrets'
require 'netbox_client_ruby/communication'

module NetboxClientRuby
  module Secrets
    {
      secret_roles: SecretRoles,
      secrets: Secrets
    }.each_pair do |method_name, class_name|
      define_method(method_name) { class_name.new }
      module_function(method_name)
    end

    {
      secret_role: SecretRole,
      secret: Secret
    }.each_pair do |method_name, class_name|
      define_method(method_name) { |id| class_name.new id }
      module_function(method_name)
    end
  end
end
