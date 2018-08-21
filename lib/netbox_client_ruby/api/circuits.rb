require 'netbox_client_ruby/api/circuits/circuit'
require 'netbox_client_ruby/api/circuits/circuits'
require 'netbox_client_ruby/api/circuits/circuit_termination'
require 'netbox_client_ruby/api/circuits/circuit_terminations'
require 'netbox_client_ruby/api/circuits/circuit_type'
require 'netbox_client_ruby/api/circuits/circuit_types'
require 'netbox_client_ruby/api/circuits/provider'
require 'netbox_client_ruby/api/circuits/providers'
require 'netbox_client_ruby/communication'

module NetboxClientRuby
  module Circuits
    {
      providers: Providers,
      circuits: Circuits,
      circuit_types: CircuitTypes,
      circuit_terminations: CircuitTerminations
    }.each_pair do |method_name, class_name|
      define_method(method_name) { class_name.new }
      module_function(method_name)
    end

    {
      provider: Provider,
      circuit: Circuit,
      circuit_type: CircuitType,
      circuit_termination: CircuitTermination
    }.each_pair do |method_name, class_name|
      define_method(method_name) { |id| class_name.new id }
      module_function(method_name)
    end
  end
end
