# frozen_string_literal: true

module NetboxClientRuby
  module DCIM
    class Platform
      include Entity

      id id: :id
      deletable true
      path 'dcim/platforms/:id/'
      creation_path 'dcim/platforms/'
      object_fields(
        manufacturer: proc do |raw_manufacturer|
          DCIM::Manufacturer.new raw_manufacturer['id']
        end
      )
    end
  end
end
