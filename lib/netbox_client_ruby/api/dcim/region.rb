# frozen_string_literal: true

module NetboxClientRuby
  module DCIM
    class Region
      include Entity

      id id: :id
      deletable true
      path 'dcim/regions/:id/'
      creation_path 'dcim/regions/'
      object_fields parent: proc { |raw_data| Region.new raw_data['id'] }
    end
  end
end
