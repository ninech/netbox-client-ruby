# frozen_string_literal: true

require 'spec_helper'
require 'uri'

RSpec.describe NetboxClientRuby::Connection do
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
      expect(described_class.new).to be_a Faraday::Connection
    end

    it 'correctly sets the base url' do
      expect(described_class.new.url_prefix)
        .to eq(URI.parse('https://netbox.test/api/'))
    end

    it 'sets the correct auth headers' do
      actual_headers = described_class.new.headers
      expect(actual_headers['Authorization']).to eq 'Token 2e35594ec8710e9922d14365a1ea66f27ea69450'
    end

    context 'session_key given' do
      let(:expected_session_key) { 'lolkeyhaha' }

      before do
        NetboxClientRuby::Secrets.session_key = expected_session_key
      end

      after do
        NetboxClientRuby::Secrets.session_key = nil
      end

      it 'adds the session_key header if available' do
        actual_headers = described_class.new.headers

        expect(actual_headers['X-Session-Key']).to eq expected_session_key
      end
    end

    it 'sets the adapter' do
      if Faraday::VERSION < '1.0'
        expect(described_class.new.builder.handlers)
          .to include Faraday::Adapter::NetHttp
      else
        expect(described_class.new.builder.adapter)
          .to eq Faraday::Adapter::NetHttp
      end
    end

    it 'adds the json middleware' do
      if Faraday::VERSION < '1.10.0'
        expect(described_class.new.builder.handlers)
          .to include FaradayMiddleware::ParseJson
      else
        expect(described_class.new.builder.handlers)
          .to include Faraday::Request::Json, Faraday::Response::Json
      end
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
      if Faraday::VERSION < '1.0'
        expect(described_class.new.builder.handlers)
          .to include Faraday::Adapter::NetHttpPersistent
      else
        expect(described_class.new.builder.adapter)
          .to eq Faraday::Adapter::NetHttpPersistent
      end
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
        expect(described_class.new.builder.handlers)
          .to include Faraday::Response::Logger
      end
    end

    # For old versions of Faraday prior to Faraday 0.16.x, it does not appear to
    # be possible to set the current version of faraday-detailed_logger, which raises the error
    #
    #  Faraday::Error:
    #      :detailed_logger is not registered on Faraday::Response
    #
    # Because this version range of Faraday is so old, we skip the test rather
    # than attempting to backport this optional feature.
    if Faraday::VERSION > '0.16'
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
          expect(described_class.new.builder.handlers)
            .to include Faraday::DetailedLogger::Middleware
        end
      end
    end
  end
end
