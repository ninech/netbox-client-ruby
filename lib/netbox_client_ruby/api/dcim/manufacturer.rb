# frozen_string_literal: true

module NetboxClientRuby
  module DCIM
    class Manufacturer
      include Entity

      id id: :id
      deletable true
      path 'dcim/manufacturers/:id.json'
      creation_path 'dcim/manufacturers/'
    end
  end
end
