require 'netbox_client_ruby/entity'
require 'netbox_client_ruby/api/dcim/device'
require 'netbox_client_ruby/api/dcim/console_server_port'

module NetboxClientRuby
  module DCIM
    class ConsolePort
      include Entity

      id id: :id
      deletable true
      path 'dcim/console-ports/:id.json'
      creation_path 'dcim/console-ports/'

      object_fields(
        device: proc { |raw_data| Device.new raw_data['id'] },
        cs_port: proc { |raw_data| ConsoleServerPort.new raw_data['id'] },
      )
    end
  end
end
