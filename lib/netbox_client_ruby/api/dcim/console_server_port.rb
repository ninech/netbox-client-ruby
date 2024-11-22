# frozen_string_literal: true

module NetboxClientRuby
  module DCIM
    class ConsoleServerPort
      include Entity

      id id: :id
      deletable true
      path 'dcim/console-server-ports/:id/'
      creation_path 'dcim/console-server-ports/'

      object_fields(
        device: proc { |raw_data| Device.new raw_data['id'] },
        connected_console: proc { |raw_data| ConsolePort.new raw_data },
      )
    end
  end
end
