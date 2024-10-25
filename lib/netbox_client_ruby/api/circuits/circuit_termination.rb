# frozen_string_literal: true

module NetboxClientRuby
  module Circuits
    class CircuitTermination
      include Entity

      id id: :id
      deletable true
      path 'circuits/circuit-terminations/:id.json'
      creation_path 'circuits/circuit-terminations/'

      object_fields(
        circuit: proc { |raw_data| Circuit::Circuit.new raw_data['id'] },
        site: proc { |raw_data| DCIM::Site.new raw_data['id'] },
        interface: proc { |raw_data| DCIM::Interface.new raw_data['id'] }
      )
    end
  end
end
