# frozen_string_literal: true

require 'spec_helper'

RSpec.describe NetboxClientRuby::DCIM::Cable, faraday_stub: true do
  subject { sut.new entity_id }

  let(:entity_id) { 1 }
  let(:expected_type) { 'cat5' }
  let(:sut) { described_class }
  let(:base_url) { '/api/dcim/cables/' }

  let(:request_url) { "#{base_url}#{entity_id}/" }
  let(:response) { File.read("spec/fixtures/dcim/cable_#{entity_id}.json") }

  describe '#id' do
    it 'shall be the expected id' do
      expect(subject.id).to eq(entity_id)
    end
  end

  describe '#type' do
    it 'fetches the data' do
      allow(faraday).to receive(:get).and_call_original

      expect(subject.type).to_not be_nil
    end

    it 'shall be the expected type' do
      expect(subject.type).to eq(expected_type)
    end
  end

  describe '.delete' do
    let(:request_method) { :delete }
    let(:response_status) { 204 }
    let(:response) { nil }

    it 'deletes the object' do
      expect(faraday).to receive(request_method).and_call_original
      subject.delete
    end
  end

  describe '.update' do
    let(:request_method) { :patch }
    let(:request_params) { { 'type' => 'coaxial' } }

    it 'updates the object' do
      expect(faraday).to receive(request_method).and_call_original
      expect(subject.update(type: 'coaxial').type).to eq(expected_type)
    end
  end

  describe '.reload' do
    it 'reloads the object' do
      expect(faraday).to receive(request_method).twice.and_call_original

      subject.reload
      subject.reload
    end
  end

  describe '.save' do
    let(:type) { 'coaxial' }
    let(:request_params) { { 'type' => type } }

    context 'update' do
      subject do
        cable = sut.new entity_id
        cable.type = type
        cable
      end

      let(:request_method) { :patch }

      it 'does not call PATCH until save is called' do
        expect(faraday).to_not receive(request_method)
        expect(faraday).to_not receive(:get)

        expect(subject.type).to eq(type)
      end

      it 'calls PATCH when save is called' do
        expect(faraday).to receive(request_method).and_call_original

        expect(subject.save).to be(subject)
      end

      it 'Reads the answer from the PATCH answer' do
        expect(faraday).to receive(request_method).and_call_original

        subject.save
        expect(subject.type).to eq(expected_type)
      end
    end

    context 'create' do
      subject do
        cable = sut.new
        cable.type = type
        cable
      end

      let(:request_method) { :post }
      let(:request_url) { base_url }

      it 'does not POST until save is called' do
        expect(faraday).to_not receive(request_method)
        expect(faraday).to_not receive(:get)

        expect(subject.type).to eq(type)
      end

      it 'POSTs the data upon a call of save' do
        expect(faraday).to receive(request_method).and_call_original

        expect(subject.save).to be(subject)
      end

      it 'Reads the answer from the POST' do
        expect(faraday).to receive(request_method).and_call_original

        subject.save

        expect(subject.id).to be(1)
        expect(subject.type).to eq(expected_type)
      end
    end
  end
end
