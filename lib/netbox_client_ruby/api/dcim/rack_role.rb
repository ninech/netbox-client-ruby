# frozen_string_literal: true

module NetboxClientRuby
  module DCIM
    class RackRole
      include Entity

      id id: :id
      deletable true
      path 'dcim/rack-roles/:id/'
      creation_path 'dcim/rack-roles/'
    end
  end
end
