require 'netbox_client_ruby/entity'
# require 'netbox_client_ruby/api/dcim/interface'
require 'netbox_client_ruby/api/ipam/vrf'
require 'netbox_client_ruby/api/tenancy/tenant'

module NetboxClientRuby
  class IpAddress
    include NetboxClientRuby::Entity

    id id: :id
    deletable true
    path 'ipam/ip-addresses/:id.json'
    creation_path 'ipam/ip-addresses/'
    object_fields(
      vrf: proc { |raw_data| NetboxClientRuby::Vrf.new raw_data['id'] },
      tenant: proc { |raw_data| NetboxClientRuby::Tenant.new raw_data['id'] },
      status: proc { |raw_data| NetboxClientRuby::IpAddressStatus.new raw_data['value'] },
      # interface: proc { |raw_data| NetboxClientRuby::Interface.new raw_data['id'] }
    )
    readonly_fields :display_name

  end

  class IpAddressStatus
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
               when 5 then
                 'DHCP'.freeze
               else
                 'UNDEFINED'.freeze
               end
    end
  end
end
