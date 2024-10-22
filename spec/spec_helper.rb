# frozen_string_literal: true

require 'bundler/setup'
require 'netbox-client-ruby'
require 'shared_context'
require 'faraday/net_http_persistent' if Faraday::VERSION > '2'

RSpec.configure do |config|
  config.example_status_persistence_file_path = '.rspec_status'

  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'
  config.include_context 'connection setup'

  config.fail_if_no_examples = true

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # disable monkey patching
  # see: https://rspec.info/features/3-12/rspec-core/configuration/zero-monkey-patching-mode/
  config.disable_monkey_patching!
end
