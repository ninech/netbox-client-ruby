require 'netbox_client_ruby/api/dcim/regions'
require 'netbox_client_ruby/api/dcim/region'
require 'netbox_client_ruby/api/dcim/sites'
require 'netbox_client_ruby/api/dcim/site'
require 'netbox_client_ruby/communication'

module NetboxClientRuby
  class DCIM
    def sites
      Sites.new
    end

    def site(id)
      Site.new id
    end

    def regions
      Regions.new
    end

    def region(id)
      Region.new id
    end
  end
end
