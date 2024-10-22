# frozen_string_literal: true

require 'spec_helper'

RSpec.describe NetboxClientRuby::Circuits do
  {
    providers: NetboxClientRuby::Circuits::Providers,
    circuits: NetboxClientRuby::Circuits::Circuits,
    circuit_terminations: NetboxClientRuby::Circuits::CircuitTerminations,
    circuit_types: NetboxClientRuby::Circuits::CircuitTypes
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

  {
    provider: NetboxClientRuby::Circuits::Provider,
    circuit: NetboxClientRuby::Circuits::Circuit,
    circuit_termination: NetboxClientRuby::Circuits::CircuitTermination,
    circuit_type: NetboxClientRuby::Circuits::CircuitType
  }.each do |method, expected_class|
    describe ".#{method}" do
      let(:id) { 1 }
      subject { described_class.public_send(method, id) }

      context 'is of the expected type' do
        it { is_expected.to be_a expected_class }
      end

      context 'it is a new instance each time' do
        it do
          is_expected
            .to_not be described_class.public_send(method, id)
        end
      end

      context 'is an Entity object' do
        it { is_expected.to respond_to(:get!) }
      end
    end
  end
end
