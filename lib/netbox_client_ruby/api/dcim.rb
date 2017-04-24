require 'netbox_client_ruby/communication'
require 'netbox_client_ruby/api/dcim/sites'
require 'netbox_client_ruby/api/dcim/site'
require 'uri'

module NetboxClientRuby
  class DCIM
    def sites
      Sites.new
    end

    def site(id)
      Site.new id
    end
  end
end
