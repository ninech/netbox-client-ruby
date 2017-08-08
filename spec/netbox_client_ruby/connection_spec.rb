require 'spec_helper'
require 'uri'

describe NetboxClientRuby::Connection do
  describe 'email and key' do
    before do
      NetboxClientRuby.configure do |config|
        config.netbox.auth.token = '2e35594ec8710e9922d14365a1ea66f27ea69450'
        config.netbox.api_base_url = 'https://netbox.test/api/'
        config.faraday.adapter = :net_http
        config.faraday.logger = nil
      end
    end

    it 'returns a Faraday::Connection' do
      expect(NetboxClientRuby::Connection.new).to be_a Faraday::Connection
    end

    it 'correctly sets the base url' do
      expect(NetboxClientRuby::Connection.new.url_prefix)
        .to eq(URI.parse('https://netbox.test/api/'))
    end

    it 'sets the correct auth headers' do
      actual_headers = NetboxClientRuby::Connection.new.headers
      expect(actual_headers['Authorization']).to eq 'Token 2e35594ec8710e9922d14365a1ea66f27ea69450'
    end

    context 'session_key given' do
      let(:expected_session_key) { 'lolkeyhaha' }

      before do
        NetboxClientRuby::Secrets.session_key = expected_session_key
      end

      it 'adds the session_key header if available' do
        actual_headers = NetboxClientRuby::Connection.new.headers

        expect(actual_headers['X-Session-Key']).to eq expected_session_key
      end

      after do
        NetboxClientRuby::Secrets.session_key = nil
      end
    end

    it 'sets the adapter' do
      expect(NetboxClientRuby::Connection.new.builder.handlers)
        .to include Faraday::Adapter::NetHttp
    end

    it 'adds the json middleware' do
      expect(NetboxClientRuby::Connection.new.builder.handlers)
        .to include FaradayMiddleware::ParseJson
    end
  end

  describe 'alternative adapter' do
    before do
      NetboxClientRuby.configure do |config|
        config.netbox.auth.token = '2e35594ec8710e9922d14365a1ea66f27ea69450'
        config.netbox.api_base_url = 'https://netbox.test/api/'
        config.faraday.adapter = :net_http_persistent
      end
    end

    it 'sets the adapter' do
      expect(NetboxClientRuby::Connection.new.builder.handlers)
        .to include Faraday::Adapter::NetHttpPersistent
    end
  end

  describe 'alternative logger' do
    context 'faraday logger' do
      before do
        NetboxClientRuby.configure do |config|
          config.netbox.auth.token = '2e35594ec8710e9922d14365a1ea66f27ea69450'
          config.netbox.api_base_url = 'https://netbox.test/api/'
          config.faraday.logger = :logger
          config.faraday.adapter = :net_http
        end
      end

      it 'sets the logger' do
        expect(NetboxClientRuby::Connection.new.builder.handlers)
          .to include Faraday::Response::Logger
      end
    end

    context 'detailed logger' do
      before do
        NetboxClientRuby.configure do |config|
          config.netbox.auth.token = '2e35594ec8710e9922d14365a1ea66f27ea69450'
          config.netbox.api_base_url = 'https://netbox.test/api/'
          config.faraday.logger = :detailed_logger
          config.faraday.adapter = :net_http
        end
      end

      it 'sets the logger' do
        expect(NetboxClientRuby::Connection.new.builder.handlers)
          .to include Faraday::DetailedLogger::Middleware
      end
    end
  end
end
