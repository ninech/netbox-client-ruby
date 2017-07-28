require 'netbox_client_ruby/api/dcim'
require 'netbox_client_ruby/api/ipam'
require 'netbox_client_ruby/api/tenancy'
require 'netbox_client_ruby/communication'

module NetboxClientRuby
  def self.dcim
    @dcim ||= NetboxClientRuby::DCIM
  end

  def self.tenancy
    @tenancy ||= NetboxClientRuby::Tenancy
  end

  def self.ipam
    @ipam ||= NetboxClientRuby::IPAM
  end
end
