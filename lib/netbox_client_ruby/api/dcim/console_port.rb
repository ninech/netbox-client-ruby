# frozen_string_literal: true

module NetboxClientRuby
  module DCIM
    class ConsolePort
      include Entity

      id id: :id
      deletable true
      path 'dcim/console-ports/:id/'
      creation_path 'dcim/console-ports/'

      object_fields(
        device: proc { |raw_data| Device.new raw_data['id'] },
        cs_port: proc { |raw_data| ConsoleServerPort.new raw_data['id'] },
      )
    end
  end
end
