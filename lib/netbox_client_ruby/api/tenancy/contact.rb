# frozen_string_literal: true

module NetboxClientRuby
  module Tenancy
    class Contact
      include Entity

      id id: :id
      deletable true
      path 'tenancy/contacts/:id/'
      creation_path 'tenancy/contacts/'
      object_fields group: proc { |raw_data| ContactGroup.new raw_data['id'] }
    end
  end
end
