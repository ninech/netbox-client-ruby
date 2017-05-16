require 'netbox_client_ruby/entity'
require 'netbox_client_ruby/api/ipam/role'
require 'netbox_client_ruby/api/dcim/site'
require 'netbox_client_ruby/api/ipam/vrf'
require 'netbox_client_ruby/api/ipam/vlan'
require 'netbox_client_ruby/api/ipam/vlan_group'
require 'netbox_client_ruby/api/tenancy/tenant'
require 'ipaddress'

module NetboxClientRuby
  class Prefix
    include NetboxClientRuby::Entity

    id id: :id
    deletable true
    path 'ipam/prefixes/:id.json'
    creation_path 'ipam/prefixes/'
    object_fields(
      site: proc { |raw_data| NetboxClientRuby::Site.new raw_data['id'] },
      vrf: proc { |raw_data| NetboxClientRuby::Vrf.new raw_data['id'] },
      tenant: proc { |raw_data| NetboxClientRuby::Tenant.new raw_data['id'] },
      vlan: proc { |raw_data| NetboxClientRuby::Vlan.new raw_data['id'] },
      status: proc { |raw_data| NetboxClientRuby::PrefixStatus.new raw_data['value'] },
      role: proc { |raw_data| NetboxClientRuby::Role.new raw_data['id'] },
      prefix: proc { |raw_data| IPAddress.parse raw_data }
    )
    readonly_fields :display_name
  end

  class PrefixStatus
    attr_reader :value, :label

    def initialize(status_value)
      @value = status_value
      @label = case status_value
               when 0 then
                 'Container'.freeze
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
