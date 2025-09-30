# frozen_string_literal: true

require_relative 'lib/netbox_client_ruby/version'

Gem::Specification.new do |spec|
  spec.name          = 'netbox-client-ruby'
  spec.version       = NetboxClientRuby::VERSION::STRING

  spec.summary       = 'A read/write client for Netbox v2.'
  spec.homepage      = 'https://github.com/ninech/netbox-client-ruby'
  spec.license       = 'MIT'

  spec.authors       = ['Nine Internet Solutions AG']
  spec.email         = ['support@nine.ch']

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org'
    spec.metadata['homepage_uri']      = 'https://github.com/ninech/netbox-client-ruby'
    spec.metadata['changelog_uri']     = 'https://github.com/ninech/netbox-client-ruby/releases'
    spec.metadata['source_code_uri']   = 'https://github.com/ninech/netbox-client-ruby'
    spec.metadata['bug_tracker_uri']   = 'https://github.com/ninech/netbox-client-ruby/issues'
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.required_ruby_version = '>= 2.7.0'

  spec.add_dependency 'dry-configurable', '~> 1'
  spec.add_dependency 'faraday', '>= 0.11.0', '< 3'
  spec.add_dependency 'faraday-detailed_logger', '~> 2.1'
  spec.add_dependency 'ipaddress', '~> 0.8', '>= 0.8.3'
  spec.add_dependency 'openssl', '>= 2.0.5'
  spec.add_dependency 'zeitwerk', '~> 2.6.0'
end
