require 'netbox_client_ruby/entities'
require 'netbox_client_ruby/api/virtualization/virtual_machine'

module NetboxClientRuby
  module Virtualization
    class VirtualMachines
      include Entities

      path 'virtualization/virtual-machines.json'
      data_key 'results'
      count_key 'count'
      entity_creator :entity_creator

      private

      def entity_creator(raw_entity)
        VirtualMachine.new raw_entity['id']
      end
    end
  end
end
