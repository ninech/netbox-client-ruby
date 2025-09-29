# frozen_string_literal: true

module NetboxClientRuby
  module Secrets
    {
      secret_roles: SecretRoles,
      secrets: Secrets,
      generate_rsa_key_pair: RSAKeyPair,
      get_session_key: SessionKey,
    }.each_pair do |method_name, class_name|
      NetboxClientRuby.load_collection(self, method_name, class_name)
    end

    {
      secret_role: SecretRole,
      secret: Secret,
    }.each_pair do |method_name, class_name|
      NetboxClientRuby.load_entity(self, method_name, class_name)
    end

    def session_key=(session_key)
      @session_key = session_key
    end

    module_function(:session_key=)

    def session_key
      @session_key
    end

    module_function(:session_key)
  end
end
