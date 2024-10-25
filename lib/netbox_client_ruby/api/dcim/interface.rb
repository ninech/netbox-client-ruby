# frozen_string_literal: true

module NetboxClientRuby
  module DCIM
    class Interface
      include Entity

      id id: :id
      deletable true
      path 'dcim/interfaces/:id.json'
      creation_path 'dcim/interfaces/'
      object_fields device: proc { |raw_data| Device.new raw_data['id'] }
    end
  end
end
