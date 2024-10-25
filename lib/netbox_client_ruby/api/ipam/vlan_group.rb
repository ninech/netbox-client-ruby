# frozen_string_literal: true

module NetboxClientRuby
  module IPAM
    class VlanGroup
      include Entity

      id id: :id
      deletable true
      path 'ipam/vlan-groups/:id.json'
      creation_path 'ipam/vlan-groups/'
      object_fields site: proc { |raw_data| DCIM::Site.new raw_data['id'] }
    end
  end
end
