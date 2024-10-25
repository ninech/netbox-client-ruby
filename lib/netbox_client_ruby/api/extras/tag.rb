# frozen_string_literal: true

module NetboxClientRuby
  module Extras
    class Tag
      include Entity

      id id: :id
      deletable true
      path 'extras/tags/:id.json'
      creation_path 'extras/tags/'
    end
  end
end
