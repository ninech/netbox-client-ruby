lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name = "netbox-client-ruby"
  spec.version = `git describe --tags --match="v[0-9]*" --abbrev=0`.strip.delete_prefix("v")

  spec.summary = "A read/write client for Netbox v2."
  spec.homepage = "https://github.com/ninech/netbox-client-ruby"
  spec.license = "MIT"

  spec.authors = ["Nine Internet Solutions AG"]
  spec.email = ["support@nine.ch"]

  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org"
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.7.0"

  spec.add_runtime_dependency "dry-configurable", "~> 1"
  spec.add_runtime_dependency "faraday", ">= 0.11.0", "< 3"
  spec.add_runtime_dependency "faraday-detailed_logger", "~> 2.1"
  spec.add_runtime_dependency "ipaddress", "~> 0.8", ">= 0.8.3"
  spec.add_runtime_dependency "openssl", ">= 2.0.5"

  spec.add_development_dependency "bundler", "~> 2.1"
  spec.add_development_dependency "pry", "~> 0.10"
  spec.add_development_dependency "rake", "~> 13"
  spec.add_development_dependency "rspec", "~> 3.5"
  spec.add_development_dependency "standard", "~> 1.31"
  spec.add_development_dependency "standard-performance", "~> 1.2"
end
