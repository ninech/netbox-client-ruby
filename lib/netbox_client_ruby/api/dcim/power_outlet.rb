# frozen_string_literal: true

module NetboxClientRuby
  module DCIM
    class PowerOutlet
      include Entity

      id id: :id
      deletable true
      path 'dcim/power-outlets/:id.json'
      creation_path 'dcim/power-outlets/'
      object_fields device: proc { |raw_data| Device.new raw_data['id'] }
      object_fields connected_port: proc { |raw_data| PowerPort.new raw_data }
    end
  end
end
