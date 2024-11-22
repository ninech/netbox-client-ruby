# frozen_string_literal: true

module NetboxClientRuby
  module DCIM
    class DeviceRole
      include Entity

      id id: :id
      deletable true
      path 'dcim/device-roles/:id/'
      creation_path 'dcim/device-roles/'
    end
  end
end
