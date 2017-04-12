require 'netbox_client_ruby/entity'

module NetboxClientRuby
  class Site
    include NetboxClientRuby::Entity

    attr_reader :id
    deletable true
    path 'dcim/sites/:id.json'

    def initialize(site_id)
      @id = site_id
    end
  end
end
