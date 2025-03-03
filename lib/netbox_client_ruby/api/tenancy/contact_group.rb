# frozen_string_literal: true

module NetboxClientRuby
  module Tenancy
    class ContactGroup
      include Entity

      id id: :id
      deletable true
      path 'tenancy/contact-groups/:id/'
      creation_path 'tenancy/contact-groups/'
      object_fields parent: proc { |raw_data| ContactGroup.new raw_data['id'] }
    end
  end
end
