# frozen_string_literal: true

require 'netbox_client_ruby/entity'

module NetboxClientRuby
  module Circuits
    class CircuitType
      include Entity

      id id: :id
      deletable true
      path 'circuits/circuit-types/:id.json'
      creation_path 'circuits/circuit-types/'
    end
  end
end
