# frozen_string_literal: true

module NetboxClientRuby
  module Core
    ##
    # A single entry of /api/core/object-changes/. Read-only: the changelog is
    # produced by NetBox, never written by clients.
    class ObjectChange
      include Entity

      id id: :id
      deletable false
      path 'core/object-changes/:id/'
    end
  end
end
