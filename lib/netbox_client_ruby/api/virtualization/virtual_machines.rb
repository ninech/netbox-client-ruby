# frozen_string_literal: true

module NetboxClientRuby
  module Virtualization
    class VirtualMachines
      include Entities

      path 'virtualization/virtual-machines/'
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
