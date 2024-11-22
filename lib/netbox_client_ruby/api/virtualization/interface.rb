# frozen_string_literal: true

module NetboxClientRuby
  module Virtualization
    class Interface
      include Entity

      id id: :id
      deletable true
      path 'virtualization/interfaces/:id/'
      creation_path 'virtualization/interfaces/'
      object_fields virtual_machine: proc { |raw_data|
        VirtualMachine.new raw_data['id']
      }
    end
  end
end
