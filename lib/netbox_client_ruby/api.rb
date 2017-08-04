require 'netbox_client_ruby/api/dcim'
require 'netbox_client_ruby/api/ipam'
require 'netbox_client_ruby/api/secrets'
require 'netbox_client_ruby/api/tenancy'
require 'netbox_client_ruby/communication'

module NetboxClientRuby
  def self.dcim
    NetboxClientRuby::DCIM
  end

  def self.ipam
    NetboxClientRuby::IPAM
  end

  def self.secrets
    NetboxClientRuby::Secrets
  end

  def self.tenancy
    NetboxClientRuby::Tenancy
  end
end
