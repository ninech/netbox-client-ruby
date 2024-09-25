# frozen_string_literal: true

require 'netbox_client_ruby/entity'

module NetboxClientRuby
  module DCIM
    class DeviceRole
      include Entity

      id id: :id
      deletable true
      path 'dcim/device-roles/:id.json'
      creation_path 'dcim/device-roles/'
    end
  end
end
