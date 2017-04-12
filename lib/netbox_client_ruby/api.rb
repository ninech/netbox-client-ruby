require 'netbox_client_ruby/communication'
require 'netbox_client_ruby/api/dcim'

module NetboxClientRuby
  def self.dcim
    NetboxClientRuby::DCIM.new
  end
end
