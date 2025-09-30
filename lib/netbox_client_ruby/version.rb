# frozen_string_literal: true

module NetboxClientRuby
  def self.gem_version
    Gem::Version.new VERSION::STRING
  end

  module VERSION
    STRING = File.read(File.expand_path('../../VERSION', __dir__)).strip
  end
end
