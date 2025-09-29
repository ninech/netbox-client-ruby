# frozen_string_literal: true

module NetboxClientRuby
  module Circuits
    {
      providers: Providers,
      circuits: Circuits,
      circuit_types: CircuitTypes,
      circuit_terminations: CircuitTerminations,
    }.each_pair do |method_name, class_name|
      NetboxClientRuby.load_collection(self, method_name, class_name)
    end

    {
      provider: Provider,
      circuit: Circuit,
      circuit_type: CircuitType,
      circuit_termination: CircuitTermination,
    }.each_pair do |method_name, class_name|
      NetboxClientRuby.load_entity(self, method_name, class_name)
    end
  end
end
