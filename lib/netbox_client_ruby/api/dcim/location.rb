module NetboxClientRuby
  module DCIM
    class Location
      include Entity

      id id: :id
      deletable true
      path 'dcim/locations/:id/'
      creation_path 'dcim/locations/'
    end
  end
end