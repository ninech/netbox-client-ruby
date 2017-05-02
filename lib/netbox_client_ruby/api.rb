require 'netbox_client_ruby/communication'
require 'netbox_client_ruby/api/dcim'
require 'netbox_client_ruby/api/tenancy'

module NetboxClientRuby
  def self.dcim
    @dcim ||= NetboxClientRuby::DCIM.new
  end

  def self.tenancy
    @tenancy ||= NetboxClientRuby::Tenancy.new
  end
end
