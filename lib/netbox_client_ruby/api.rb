require 'netbox_client_ruby/api/circuits'
require 'netbox_client_ruby/api/dcim'
require 'netbox_client_ruby/api/extras'
require 'netbox_client_ruby/api/ipam'
require 'netbox_client_ruby/api/secrets'
require 'netbox_client_ruby/api/tenancy'
require 'netbox_client_ruby/api/virtualization'
require 'netbox_client_ruby/communication'

module NetboxClientRuby
  def self.circuits
    NetboxClientRuby::Circuits
  end

  def self.dcim
    NetboxClientRuby::DCIM
  end

  def self.extras
    NetboxClientRuby::Extras
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

  def self.virtualization
    NetboxClientRuby::Virtualization
  end
end
