require 'netbox_client_ruby/entity'
require 'netbox_client_ruby/api/circuits/circuit'
require 'netbox_client_ruby/api/dcim/site'
require 'netbox_client_ruby/api/dcim/interface'

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
