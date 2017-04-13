require 'spec_helper'
require 'faraday'
require 'faraday_middleware'

RSpec.shared_context 'connection setup' do
  let(:faraday_logger) { nil }
  let(:netbox_auth_token) { 'this-is-the-test-token' }
  let(:netbox_api_base_url) { 'http://netbox.test/api/' }

  let(:faraday_stubs) { Faraday::Adapter::Test::Stubs.new }
  let(:faraday) do
    Faraday.new(url: Cloudflair.config.netbox.api_base_url, headers: NetboxClientRuby::Connection.headers) do |faraday|
      faraday.adapter :test, faraday_stubs
      faraday.request :json
      faraday.response :json, content_type: /\bjson$/
      faraday.request faraday_logger if faraday_logger
    end
  end

  before do
    NetboxClientRuby.configure do |config|
      config.netbox.auth.token = netbox_auth_token
      config.netbox.api_base_url = netbox_api_base_url
    end
  end
end
