require 'netbox_client_ruby/entity'
require 'netbox_client_ruby/api/dcim/manufacturer'

module NetboxClientRuby
  module DCIM
    class Platform
      include Entity

      id id: :id
      deletable true
      path 'dcim/platforms/:id.json'
      creation_path 'dcim/platforms/'
      object_fields(
        manufacturer: proc do |raw_manufacturer|
          DCIM::Manufacturer.new raw_manufacturer['id']
        end
      )
    end
  end
end
