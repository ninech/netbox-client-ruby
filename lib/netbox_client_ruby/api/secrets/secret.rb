# frozen_string_literal: true

module NetboxClientRuby
  module Secrets
    class Secret
      include Entity

      id id: :id
      deletable true
      path 'secrets/secrets/:id.json'
      creation_path 'secrets/secrets/'
      object_fields device: proc { |raw_data| Device.new raw_data['id'] },
                    role: proc { |raw_data| SecretRole.new raw_data['id'] }
    end
  end
end
