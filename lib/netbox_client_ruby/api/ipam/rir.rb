# frozen_string_literal: true

module NetboxClientRuby
  module IPAM
    class Rir
      include Entity

      id id: :id
      deletable true
      path 'ipam/rirs/:id.json'
      creation_path 'ipam/rirs/'
    end
  end
end
