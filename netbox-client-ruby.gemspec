lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = 'netbox-client-ruby'
  spec.version       = File.read(File.expand_path('VERSION', __dir__)).strip

  spec.summary       = 'A read/write client for Netbox v2.'
  spec.homepage      = 'https://github.com/ninech/netbox-client-ruby'
  spec.license       = 'MIT'

  spec.authors       = ['Christian Mäder']
  spec.email         = ['christian.maeder@nine.ch']

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.6.0'

  spec.add_runtime_dependency 'dry-configurable', '~> 1'
  spec.add_runtime_dependency 'faraday', '>= 0.11.0', '< 2'
  spec.add_runtime_dependency 'faraday-detailed_logger', '~> 2.1'
  spec.add_runtime_dependency 'faraday_middleware', '>= 0.11', '< 2'
  spec.add_runtime_dependency 'ipaddress', '~> 0.8', '>= 0.8.3'
  spec.add_runtime_dependency 'openssl', '>= 2.0.5'

  spec.add_development_dependency 'bundler', '~> 2.1'
  spec.add_development_dependency 'pry', '~> 0.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.5'
  spec.add_development_dependency 'rubocop', '~> 0.48'
  spec.add_development_dependency 'rubocop-rspec', '~> 1.15'
end
