require 'netbox_client_ruby/entity'
require 'netbox_client_ruby/api/tenancy/tenant'
require 'netbox_client_ruby/api/ipam/role'
require 'netbox_client_ruby/api/ipam/vlan_group'

module NetboxClientRuby
  class Vlan
    include NetboxClientRuby::Entity

    id id: :id
    deletable true
    path 'ipam/vlans/:id.json'
    creation_path 'ipam/vlans/'
    object_fields(
      tenant: proc { |raw_data| NetboxClientRuby::Tenant.new raw_data['id'] },
      role: proc { |raw_data| NetboxClientRuby::Role.new raw_data['id'] },
      status: proc { |raw_data| NetboxClientRuby::VlanStatus.new raw_data['value'] },
      group: proc { |raw_data| NetboxClientRuby::VlanGroup.new raw_data['id'] }
    )
    readonly_fields :display_name

  end

  class VlanStatus
    attr_reader :value, :label

    def initialize(status_value)
      @value = status_value
      @label = case status_value
               when 1 then
                 'Active'.freeze
               when 2 then
                 'Reserved'.freeze
               when 3 then
                 'Deprecated'.freeze
               else
                 'UNDEFINED'.freeze
               end
    end
  end
end
