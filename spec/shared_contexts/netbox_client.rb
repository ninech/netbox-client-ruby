# frozen_string_literal: true

require "dry/configurable/test_interface"

# https://dry-rb.org/gems/dry-configurable/1.0/testing/
module NetboxClientRuby
  enable_test_interface
end

RSpec.shared_context 'connection setup' do
  let(:netbox_auth_token) { 'this-is-the-test-token' }
  let(:netbox_api_base_url) { 'http://netbox.test/api/' }
  let(:netbox_auth_rsa_private_key_file) { 'spec/fixtures/secrets/rsa_private_key' }
  let(:netbox_auth_rsa_private_key_pass) { nil }

  before do
    NetboxClientRuby.reset_config
    NetboxClientRuby.configure do |config|
      config.netbox.auth.token = netbox_auth_token
      config.netbox.auth.rsa_private_key.path = netbox_auth_rsa_private_key_file
      config.netbox.auth.rsa_private_key.password = netbox_auth_rsa_private_key_pass
      config.netbox.api_base_url = netbox_api_base_url
      config.netbox.pagination.default_limit = 42
      config.netbox.pagination.max_limit = 9999
    end
  end
end
