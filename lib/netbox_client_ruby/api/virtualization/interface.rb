require 'netbox_client_ruby/entity'
require 'netbox_client_ruby/api/virtualization/virtual_machine'

module NetboxClientRuby
  module Virtualization
    class Interface
      include Entity

      id id: :id
      deletable true
      path 'virtualization/interfaces/:id.json'
      creation_path 'virtualization/interfaces/'
      object_fields virtual_machine: proc { |raw_data|
        # https://github.com/digitalocean/netbox/issues/1794
        VirtualMachine.new(raw_data.is_a?(Hash) ? raw_data['id'] : raw_data)
      }
    end
  end
end
