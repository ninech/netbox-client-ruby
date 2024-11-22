# frozen_string_literal: true

module NetboxClientRuby
  module Circuits
    class CircuitType
      include Entity

      id id: :id
      deletable true
      path 'circuits/circuit-types/:id/'
      creation_path 'circuits/circuit-types/'
    end
  end
end
