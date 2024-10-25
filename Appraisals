# frozen_string_literal: true

appraise 'faraday0' do
  gem 'faraday', '< 1.0'
  gem 'faraday_middleware', '< 1'
end

appraise 'faraday1' do
  gem 'faraday', '= 1.0'
  gem 'faraday_middleware', '< 2'
end

appraise 'faraday2' do
  gem 'faraday', '< 3'
  gem 'faraday-net_http_persistent'
  remove_gem "faraday_middleware"
end
