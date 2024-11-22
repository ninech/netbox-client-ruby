# frozen_string_literal: true

module NetboxClientRuby
  module IPAM
    class Aggregate
      include Entity

      id id: :id
      deletable true
      path 'ipam/aggregates/:id/'
      creation_path 'ipam/aggregates/'
      object_fields rir: proc { |raw_data| Rir.new raw_data['id'] }
    end
  end
end
