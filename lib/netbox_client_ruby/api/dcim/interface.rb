require 'netbox_client_ruby/entity'
require 'netbox_client_ruby/api/dcim/device'

module NetboxClientRuby
  class Interface
    include NetboxClientRuby::Entity

    id id: :id
    deletable true
    path 'dcim/interfaces/:id.json'
    creation_path 'dcim/interfaces/'
    object_fields device: proc { |raw_data| NetboxClientRuby::Device.new raw_data['id'] }

  end
end
