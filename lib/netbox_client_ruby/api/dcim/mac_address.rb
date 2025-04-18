# frozen_string_literal: true

module NetboxClientRuby
  module DCIM
    class MacAddress
      include Entity

      id id: :id
      deletable true
      path 'dcim/mac-addresses/:id/'
      creation_path 'dcim/mac-addresses/'
    end
  end
end
