# frozen_string_literal: true

require 'spec_helper'

RSpec.describe NetboxClientRuby::Secrets::SessionKey, faraday_stub: true do
  let(:request_method) { :post }
  let(:request_url) { '/api/secrets/get-session-key/' }
  let(:request_params) { { private_key: File.read('spec/fixtures/secrets/rsa_private_key') } }
  let(:response) { File.read('spec/fixtures/secrets/get-session-key.json') }
  let(:expected_session_key) { '+8t4SI6XikgVmB5+/urhozx9O5qCQANyOk1MNe6taRf=' }

  after do
    NetboxClientRuby.secrets.session_key = nil
  end

  describe '#session_key' do
    context 'unencrypted key' do
      it 'receives the session key' do
        expect(faraday).to receive(request_method).and_call_original

        expect(subject.session_key).to eql(expected_session_key)
      end

      it 'sets the session_key for future requests with secrets' do
        subject.session_key

        expect(NetboxClientRuby::Secrets.session_key).to eql(expected_session_key)
      end

      context 'but password is given' do
        let(:netbox_auth_rsa_private_key_pass) { 'unnecessary_password' }

        it 'receives the session key anyway' do
          expect(faraday).to receive(request_method).and_call_original

          expect(subject.session_key).to eql(expected_session_key)
        end
      end
    end

    context 'encrypted key' do
      let(:netbox_auth_rsa_private_key_file) { 'spec/fixtures/secrets/rsa_private_key_pwd' }
      let(:netbox_auth_rsa_private_key_pass) { 'password' }

      it 'receives the session key' do
        expect(faraday).to receive(request_method).and_call_original

        expect(subject.session_key).to eql(expected_session_key)
      end

      context 'but a wrong password is given' do
        let(:netbox_auth_rsa_private_key_pass) { 'wrong_password' }
        it 'does not send any request to the server' do
          expect(faraday).to_not receive(request_method)

          expect { subject.session_key }.to raise_error(NetboxClientRuby::LocalError)
        end
      end

      context 'but no password is given' do
        let(:netbox_auth_rsa_private_key_pass) { nil }

        it 'does not send any request to the server' do
          expect(faraday).to_not receive(request_method)

          expect { subject.session_key }.to raise_error(NetboxClientRuby::LocalError)
        end
      end
    end

    context 'invalid path' do
      let(:netbox_auth_rsa_private_key_file) { '/does/not/exists' }

      it 'does not send any request to the server' do
        expect(faraday).to_not receive(request_method)

        expect { subject.session_key }.to raise_error(NetboxClientRuby::LocalError)
      end
    end

    context 'empty key' do
      let(:netbox_auth_rsa_private_key_file) { 'spec/fixtures/secrets/empty_file' }

      it 'does not send any request to the server' do
        expect(faraday).to_not receive(request_method)

        expect { subject.session_key }.to raise_error(NetboxClientRuby::LocalError)
      end
    end

    context 'existing session key' do
      before do
        NetboxClientRuby.secrets.session_key = expected_session_key
      end

      it 'does not send a request to the server' do
        expect(faraday).to_not receive(request_method)

        expect(subject.session_key).to eql(expected_session_key)
      end
    end
  end

  describe '#reload' do
    before do
      NetboxClientRuby.secrets.session_key = expected_session_key
    end

    it 'sends a request to the server' do
      expect(faraday).to receive(request_method).once.and_call_original

      expect(subject.reload).to eql(expected_session_key)
      expect(subject.session_key).to eql(expected_session_key)
    end

    it 'always sends a request to the server' do
      expect(faraday).to receive(request_method).twice.and_call_original

      expect(subject.reload).to eql(expected_session_key)
      expect(subject.reload).to eql(expected_session_key)
    end
  end
end
