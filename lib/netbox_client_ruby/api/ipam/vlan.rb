# frozen_string_literal: true

module NetboxClientRuby
  module IPAM
    class Vlan
      include Entity

      id id: :id
      deletable true
      path 'ipam/vlans/:id/'
      creation_path 'ipam/vlans/'
      object_fields(
        tenant: proc { |raw_data| Tenancy::Tenant.new raw_data['id'] },
        role: proc { |raw_data| Role.new raw_data['id'] },
        status: proc { |raw_data| VlanStatus.new raw_data },
        group: proc { |raw_data| VlanGroup.new raw_data['id'] },
        site: proc { |raw_data| DCIM::Site.new raw_data['id'] },
      )
      readonly_fields :display_name
    end

    class VlanStatus
      attr_reader :value, :label

      def initialize(raw_data)
        @value = raw_data['value']
        @label = raw_data['label']
      end
    end
  end
end
