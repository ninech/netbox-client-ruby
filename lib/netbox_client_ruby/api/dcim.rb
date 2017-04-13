require 'netbox_client_ruby/communication'
require 'netbox_client_ruby/api/dcim/sites'
require 'uri'

module NetboxClientRuby
  class DCIM
    def sites
      Sites.new
    end
  end
end
