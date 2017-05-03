require 'netbox_client_ruby/entity'
require 'netbox_client_ruby/api/ipam/rir'

module NetboxClientRuby
  class Aggregate
    include NetboxClientRuby::Entity

    id id: :id
    deletable true
    path 'ipam/aggregates/:id.json'
    creation_path 'ipam/aggregates/'
    object_fields rir: proc { |raw_data| NetboxClientRuby::Rir.new raw_data['id'] }

  end
end
