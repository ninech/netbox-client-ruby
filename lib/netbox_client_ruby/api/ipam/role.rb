# frozen_string_literal: true

module NetboxClientRuby
  module IPAM
    class Role
      include Entity

      id id: :id
      deletable true
      path 'ipam/roles/:id/'
      creation_path 'ipam/roles/'
    end
  end
end
