# frozen_string_literal: true

require 'spec_helper'

RSpec.describe NetboxClientRuby::Secrets::Secret, faraday_stub: true do
  let(:secret_id) { 1 }
  let(:base_url) { '/api/secrets/secrets/' }
  let(:request_url) { "#{base_url}#{secret_id}/" }
  let(:response) { File.read("spec/fixtures/secrets/secret_#{secret_id}.json") }

  subject { NetboxClientRuby::Secrets::Secret.new secret_id }

  describe '#id' do
    it 'shall be the expected id' do
      expect(subject.id).to eq(secret_id)
    end
  end

  describe '#name' do
    it 'should fetch the data' do
      expect(faraday).to receive(:get).and_call_original

      subject.name
    end

    it 'shall be the expected name' do
      expect(subject.name).to eq('secret1')
    end
  end

  describe '#plaintext' do
    context 'no plaintext value' do
      it 'should return a nil value' do
        expect(subject.plaintext).to be_nil
      end
    end

    context 'a plaintext value' do
      let(:response) { File.read("spec/fixtures/secrets/secret_#{secret_id}_with_plaintext.json") }

      it 'should return the plaintext value' do
        expect(subject.plaintext).to eql('n00b')
      end
    end
  end

  describe '.delete' do
    let(:request_method) { :delete }
    let(:response_status) { 204 }
    let(:response) { nil }

    it 'should delete the object' do
      expect(faraday).to receive(request_method).and_call_original
      subject.delete
    end
  end

  describe '.update' do
    let(:request_method) { :patch }
    let(:request_params) { { 'name' => 'noob' } }

    it 'should update the object' do
      expect(faraday).to receive(request_method).and_call_original
      expect(subject.update(name: 'noob').name).to eq('secret1')
    end
  end

  describe '.reload' do
    it 'should reload the object' do
      expect(faraday).to receive(request_method).twice.and_call_original

      subject.reload
      subject.reload
    end
  end

  describe '.save' do
    let(:name) { 'foobar' }
    let(:request_params) { { 'name' => name } }

    context 'update' do
      let(:request_method) { :patch }

      subject do
        entity = NetboxClientRuby::Secrets::Secret.new secret_id
        entity.name = name
        entity
      end

      it 'does not call PATCH until save is called' do
        expect(faraday).to_not receive(request_method)
        expect(faraday).to_not receive(:get)

        expect(subject.name).to eq(name)
      end

      it 'calls PATCH when save is called' do
        expect(faraday).to receive(request_method).and_call_original

        expect(subject.save).to be(subject)
      end

      it 'Reads the answer from the PATCH answer' do
        expect(faraday).to receive(request_method).and_call_original

        subject.save
        expect(subject.name).to eq('secret1')
      end
    end

    context 'create' do
      let(:request_method) { :post }
      let(:request_url) { base_url }

      subject do
        entity = NetboxClientRuby::Secrets::Secret.new
        entity.name = name
        entity
      end

      it 'does not POST until save is called' do
        expect(faraday).to_not receive(request_method)
        expect(faraday).to_not receive(:get)

        expect(subject.name).to eq(name)
      end

      it 'POSTs the data upon a call of save' do
        expect(faraday).to receive(request_method).and_call_original

        expect(subject.save).to be(subject)
      end

      it 'Reads the answer from the POST' do
        expect(faraday).to receive(request_method).and_call_original

        subject.save

        expect(subject.id).to be(1)
        expect(subject.name).to eq('secret1')
      end
    end
  end
end
