# frozen_string_literal: true

require 'dry-configurable'
require 'ipaddress'
require 'openssl'

require 'faraday'
require 'faraday/detailed_logger'

if Faraday::VERSION < '2'
  begin
    require 'faraday_middleware'
  rescue LoadError => e
    message = <<~MSG
      For the current version of Faraday (#{Faraday::VERSION}), "faraday_middleware"
      is a required peer dependency of "netbox-client-ruby". Please install
      "faraday_middleware" separately OR upgrade to Faraday 2, in which case,
      "faraday_middleware" is not needed to work with "netbox-client-ruby".

      #{e.message}
    MSG
    raise NetboxClientRuby::Error, message
  end
end

require 'zeitwerk'

# load zeitwerk
Zeitwerk::Loader.for_gem.tap do |loader|
  loader.ignore("#{__dir__}/netbox-client-ruby.rb")
  loader.collapse("#{__dir__}/netbox_client_ruby/api")
  loader.inflector.inflect('dcim' => 'DCIM')
  loader.inflector.inflect('ipam' => 'IPAM')
  loader.inflector.inflect('rsa_key_pair' => 'RSAKeyPair')
  # loader.log!
  loader.setup
end

# load gem errors
require_relative 'netbox_client_ruby/error'

module NetboxClientRuby
  extend Dry::Configurable

  MAX_SIGNED_64BIT_INT = 9_223_372_036_854_775_807

  setting :netbox do
    setting :api_base_url
    setting :auth do
      setting :token
      setting :rsa_private_key do
        # the default is intentionally not `~/.ssh/id_rsa`,
        # to not accidentally leak someone's main rsa private key
        setting :path, default: '~/.ssh/netbox_rsa'
        setting :password
      end
    end
    setting :pagination do
      setting :default_limit, default: 50
      setting :max_limit, default: MAX_SIGNED_64BIT_INT
    end
  end

  setting :faraday do
    setting :adapter, default: :net_http
    setting :logger
    setting :request_options, default: { open_timeout: 1, timeout: 5 }
    setting :ssl_options, default: { verify: true }
  end

  def self.load_collection(collection, method_name, class_name)
    collection.define_method(method_name) { class_name.new }
    collection.__send__(:module_function, method_name)
  end

  def self.load_entity(entity, method_name, class_name)
    entity.define_method(method_name) { |id| class_name.new id }
    entity.__send__(:module_function, method_name)
  end

  def self.circuits
    NetboxClientRuby::Circuits
  end

  def self.dcim
    NetboxClientRuby::DCIM
  end

  def self.extras
    NetboxClientRuby::Extras
  end

  def self.ipam
    NetboxClientRuby::IPAM
  end

  def self.secrets
    NetboxClientRuby::Secrets
  end

  def self.tenancy
    NetboxClientRuby::Tenancy
  end

  def self.virtualization
    NetboxClientRuby::Virtualization
  end
end
