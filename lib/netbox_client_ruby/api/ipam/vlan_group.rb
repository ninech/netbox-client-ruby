require 'netbox_client_ruby/entity'
require 'netbox_client_ruby/api/dcim/site'

module NetboxClientRuby
  class VlanGroup
    include NetboxClientRuby::Entity

    id id: :id
    deletable true
    path 'ipam/vlan-groups/:id.json'
    creation_path 'ipam/vlan-groups/'
    object_fields site: proc { |raw_data| NetboxClientRuby::Site.new raw_data['id'] }

  end
end
