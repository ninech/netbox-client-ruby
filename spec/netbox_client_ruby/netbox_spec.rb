require 'spec_helper'

describe NetboxClientRuby do
  it 'is configurable' do
    NetboxClientRuby.configure do |config|
      config.netbox.auth.token = 'my_very_special_token'
      config.netbox.api_base_url = 'https://netbox.test/api/'
      config.netbox.pagination.default_limit = 42
      config.faraday.adapter = :net_http_persistent
      config.faraday.logger = :detailed_logger
    end

    expect(NetboxClientRuby.config.netbox.auth.token).to eq 'my_very_special_token'
    expect(NetboxClientRuby.config.netbox.api_base_url).to eq 'https://netbox.test/api/'
    expect(NetboxClientRuby.config.netbox.pagination.default_limit).to eq 42
    expect(NetboxClientRuby.config.faraday.adapter).to be :net_http_persistent
    expect(NetboxClientRuby.config.faraday.logger).to be :detailed_logger
  end

  context 'dcim' do
    it 'returns an access object' do
      expect(NetboxClientRuby.dcim).to be_a NetboxClientRuby::DCIM
    end

    it 'caches the access object' do
      expect(NetboxClientRuby.dcim).to be NetboxClientRuby.dcim
    end
  end
end
