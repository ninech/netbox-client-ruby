# frozen_string_literal: true

module NetboxClientRuby
  module DCIM
    class FrontPort
      include Entity

      id id: :id
      deletable true
      path 'dcim/front-ports/:id/'
      creation_path 'dcim/front-ports/'
    end
  end
end
