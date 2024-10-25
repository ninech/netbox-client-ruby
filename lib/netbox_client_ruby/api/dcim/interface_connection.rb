# frozen_string_literal: true

module NetboxClientRuby
  module DCIM
    class InterfaceConnection
      include Entity

      id id: :id
      deletable true
      path 'dcim/interface-connections/:id.json'
      creation_path 'dcim/interface-connections/'

      object_fields(
        interface_a: proc { |raw_data| Interface.new raw_data['id'] },
        interface_b: proc { |raw_data| Interface.new raw_data['id'] },
      )
    end
  end
end
