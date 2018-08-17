require 'spec_helper'

module NetboxClientRuby
  module Circuits
    describe Circuits do
      {
        providers: Providers,
        circuits: CircuitList,
        circuit_terminations: CircuitTerminations,
        circuit_types: CircuitTypes
      }.each do |method, klass|
        describe ".#{method}" do
          subject { described_class.public_send(method) }

          context 'is of the correct type' do
            it { is_expected.to be_a klass }
          end

          context 'is a different instance each time' do
            it do
              is_expected
                .to_not be described_class.public_send(method)
            end
          end

          context 'is an Entities object' do
            it { is_expected.to respond_to(:get!) }
          end
        end
      end
    end
  end
end
