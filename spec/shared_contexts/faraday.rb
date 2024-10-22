# frozen_string_literal: true

require 'uri'

RSpec.shared_context 'faraday connection', faraday_stub: true do
  include_context 'connection setup'

  let(:faraday_logger) { nil }
  let(:faraday_stubs) { Faraday::Adapter::Test::Stubs.new }
  let(:faraday) do
    Faraday.new(url: NetboxClientRuby.config.netbox.api_base_url,
                headers: NetboxClientRuby::Connection.headers) do |faraday|
      faraday.response :json, content_type: /\bjson$/
      faraday.request faraday_logger if faraday_logger
      faraday.adapter :test, faraday_stubs
    end
  end

  let(:request_method) { :get }
  let(:request_params) { {} }
  let(:request_url_params) { nil }
  let(:response_status) { 200 }
  let(:response_config) { { content_type: 'application/json' } }
  let(:response) { '{}' }

  let(:request_url_params_string) do
    return request_url_params if request_url_params.nil?
    return "?#{request_url_params}" if request_url_params.is_a? String
    '?' + URI.encode_www_form(request_url_params)
  end

  before do
    #puts "expected request: #{request_method} #{request_url}#{request_url_params_string} (#{request_params})"
    faraday_stubs.public_send(request_method,
                              "#{request_url}#{request_url_params_string}",
                              request_params) do |_env|
      [response_status, response_config, response]
    end
    allow(Faraday).to receive(:new).and_return faraday
  end
end
