# frozen_string_literal: true

module NetboxClientRuby
  module DCIM
    class Rack
      include Entity

      id id: :id
      deletable true
      path 'dcim/racks/:id/'
      creation_path 'dcim/racks/'
    end
  end
end
