# frozen_string_literal: true

module NetboxClientRuby
  module DCIM
    class RearPort
      include Entity

      id id: :id
      deletable true
      path 'dcim/rear-ports/:id/'
      creation_path 'dcim/rear-ports/'
    end
  end
end
