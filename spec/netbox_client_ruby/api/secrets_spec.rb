require 'spec_helper'

module NetboxClientRuby
  module Secrets
    describe NetboxClientRuby::Secrets do
      {
        secret_roles: SecretRoles,
        secrets: NetboxClientRuby::Secrets::Secrets
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
        secret: Secret,
        secret_role: SecretRole
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

      describe '.generate_rsa_key_pair' do
        subject { described_class.generate_rsa_key_pair }

        context 'is of the expected type' do
          it { is_expected.to be_a RSAKeyPair }
        end

        context 'it is a new instance each time' do
          it do
            is_expected
              .to_not be described_class.generate_rsa_key_pair
          end
        end
      end

      describe '.get_session_key' do
        subject { described_class.get_session_key }

        before do
          allow_any_instance_of(NetboxClientRuby::Secrets::SessionKey).to receive(:session_key).and_return('a')
        end

        context 'is of the expected type' do
          it { is_expected.to be_a SessionKey }
        end

        context 'it is a new instance each time' do
          it do
            is_expected
              .to_not be described_class.get_session_key
          end
        end
      end
    end
  end
end
