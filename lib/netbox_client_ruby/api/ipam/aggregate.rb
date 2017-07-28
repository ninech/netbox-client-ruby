require 'netbox_client_ruby/entity'
require 'netbox_client_ruby/api/ipam/rir'

module NetboxClientRuby
  module IPAM
    class Aggregate
      include Entity

      id id: :id
      deletable true
      path 'ipam/aggregates/:id.json'
      creation_path 'ipam/aggregates/'
      object_fields rir: proc { |raw_data| Rir.new raw_data['id'] }
    end
  end
end
