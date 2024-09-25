# frozen_string_literal: true

require 'spec_helper'

RSpec.describe NetboxClientRuby::Tenancy do
  {
    tenant_groups: NetboxClientRuby::Tenancy::TenantGroups,
    tenants: NetboxClientRuby::Tenancy::Tenants,
  }.each do |method, klass|
    describe ".#{method}" do
      subject { described_class.public_send(method) }

      context 'is of the correct type' do
        it { is_expected.to be_a klass }
      end

      context 'is a different instance each time' do
        it do
          expect(subject).to_not be described_class.public_send(method)
        end
      end

      context 'is an Entities object' do
        it { is_expected.to respond_to(:get!) }
      end
    end
  end
end
