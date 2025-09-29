# frozen_string_literal: true

require 'spec_helper'

RSpec.describe NetboxClientRuby do
  it 'is configurable' do # rubocop:disable RSpec/ExampleLength
    described_class.configure do |config|
      config.netbox.auth.token = 'my_very_special_token'
      config.netbox.auth.rsa_private_key.path = 'spec/fixtures/rsa_private_key'
      config.netbox.auth.rsa_private_key.password = 'password'
      config.netbox.api_base_url = 'https://netbox.test/api/'
      config.netbox.pagination.default_limit = 42
      config.netbox.pagination.max_limit = 84
      config.faraday.adapter = :net_http_persistent
      config.faraday.logger = :detailed_logger
      config.faraday.request_options = { open_timeout: 3, timeout: 15 }
      config.faraday.ssl_options = { verify: true }
    end

    expect(described_class.config.netbox.auth.token)
      .to eq 'my_very_special_token'
    expect(described_class.config.netbox.auth.rsa_private_key.path)
      .to eq 'spec/fixtures/rsa_private_key'
    expect(described_class.config.netbox.auth.rsa_private_key.password)
      .to eq 'password'
    expect(described_class.config.netbox.api_base_url)
      .to eq 'https://netbox.test/api/'
    expect(described_class.config.netbox.pagination.default_limit)
      .to eq 42
    expect(described_class.config.netbox.pagination.max_limit)
      .to eq 84
    expect(described_class.config.faraday.adapter)
      .to be :net_http_persistent
    expect(described_class.config.faraday.logger)
      .to be :detailed_logger
    expect(described_class.config.faraday.request_options)
      .to eq(open_timeout: 3, timeout: 15)
    expect(described_class.config.faraday.ssl_options)
      .to eq(verify: true)
  end

  {
    circuits: NetboxClientRuby::Circuits,
    dcim: NetboxClientRuby::DCIM,
    ipam: NetboxClientRuby::IPAM,
    secrets: NetboxClientRuby::Secrets,
    tenancy: NetboxClientRuby::Tenancy,
  }.each do |method, klass|
    context "returns the initialized #{method} object" do
      it 'is of the correct type' do
        expect(described_class.public_send(method)).to be klass
      end
    end
  end
end
