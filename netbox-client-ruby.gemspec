# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name          = 'netbox-client-ruby'
  spec.version       = File.read(File.expand_path('VERSION', __dir__)).strip

  spec.summary       = 'A read/write client for Netbox v2.'
  spec.homepage      = 'https://github.com/ninech/netbox-client-ruby'
  spec.license       = 'MIT'

  spec.authors       = ['Christian Mäder']
  spec.email         = ['christian.maeder@nine.ch']

  spec.metadata['allowed_push_host'] = 'https://rubygems.org' if spec.respond_to?(:metadata)

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }

  spec.required_ruby_version = '>= 3.0.0'

  spec.add_dependency 'dry-configurable', '~> 1'
  spec.add_dependency 'faraday', '>= 0.11.0', '< 3'
  spec.add_dependency 'faraday-detailed_logger', '~> 2.1'
  spec.add_dependency 'ipaddress', '~> 0.8', '>= 0.8.3'
  spec.add_dependency 'openssl', '>= 2.0.5'
end
