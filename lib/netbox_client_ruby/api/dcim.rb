require 'netbox_client_ruby/communication'
require 'netbox_client_ruby/api/dcim/site'

module NetboxClientRuby
  class DCIM
    include NetboxClientRuby::Entity

    path 'dcim/sites.json'

    def sites
      raw_sites = response connection.get(path)

      raw_sites.map do |raw_site|
        site = site raw_site['id']
        site.data = raw_site
        site
      end
    end

    def site(site_id)
      NetboxClientRuby::Site.new site_id
    end
  end
end
