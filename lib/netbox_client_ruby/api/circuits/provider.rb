# frozen_string_literal: true

module NetboxClientRuby
  module Circuits
    class Provider
      include Entity

      id id: :id
      deletable true
      path 'circuits/providers/:id.json'
      creation_path 'circuits/providers/'
    end
  end
end
