# frozen_string_literal: true

require 'warning'

Warning[:deprecated]   = true
Warning[:experimental] = true
Warning[:performance]  = true if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new('3.3.0')

# Ignore all warnings in Gem dependencies
Gem.path.each do |path|
  Warning.ignore(//, path)
end

# Ignore OpenStruct warning (only used in tests)
Warning.ignore(/OpenStruct use is discouraged for performance reasons/)

# Load gem
require 'netbox-client-ruby'
require_relative 'shared_contexts/netbox_client'
require_relative 'shared_contexts/faraday'
require 'faraday/net_http_persistent' if Faraday::VERSION > '2'

# Configure rspec
RSpec.configure do |config|
  config.example_status_persistence_file_path = '.rspec_status'

  config.color = true
  config.fail_fast = false
  config.fail_if_no_examples = true

  config.order = :random
  Kernel.srand config.seed

  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.include_context 'connection setup'

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # disable monkey patching
  # see: https://rspec.info/features/3-12/rspec-core/configuration/zero-monkey-patching-mode/
  config.disable_monkey_patching!
end
