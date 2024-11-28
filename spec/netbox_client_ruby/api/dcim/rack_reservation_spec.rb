# frozen_string_literal: true

require 'spec_helper'

RSpec.describe NetboxClientRuby::DCIM::RackReservation, faraday_stub: true do
  let(:entity_id) { 1 }
  let(:expected_description) { 'Reservation 0' }
  let(:base_url) { '/api/dcim/rack-reservations/' }
  let(:response) { File.read("spec/fixtures/dcim/rack-reservation_#{entity_id}.json") }

  let(:request_url) { "#{base_url}#{entity_id}/" }

  subject { described_class.new entity_id }

  describe '#id' do
    it 'shall be the expected id' do
      expect(subject.id).to eq(entity_id)
    end
  end

  describe '#description' do
    it 'should fetch the data' do
      expect(faraday).to receive(:get).and_call_original

      expect(subject.description).to_not be_nil
    end

    it 'shall be the expected description' do
      expect(subject.description).to eq(expected_description)
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
    let(:request_params) { { 'description' => 'noob' } }

    it 'should update the object' do
      expect(faraday).to receive(request_method).and_call_original
      expect(subject.update(description: 'noob').description).to eq(expected_description)
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
    let(:description) { 'foobar' }
    let(:request_params) { { 'description' => description } }

    context 'update' do
      let(:request_method) { :patch }

      subject do
        entity = described_class.new entity_id
        entity.description = description
        entity
      end

      it 'does not call PATCH until save is called' do
        expect(faraday).to_not receive(request_method)
        expect(faraday).to_not receive(:get)

        expect(subject.description).to eq(description)
      end

      it 'calls PATCH when save is called' do
        expect(faraday).to receive(request_method).and_call_original

        expect(subject.save).to be(subject)
      end

      it 'Reads the answer from the PATCH answer' do
        expect(faraday).to receive(request_method).and_call_original

        subject.save
        expect(subject.description).to eq(expected_description)
      end
    end

    context 'create' do
      let(:request_method) { :post }
      let(:request_url) { base_url }

      subject do
        entity = described_class.new
        entity.description = description
        entity
      end

      it 'does not POST until save is called' do
        expect(faraday).to_not receive(request_method)
        expect(faraday).to_not receive(:get)

        expect(subject.description).to eq(description)
      end

      it 'POSTs the data upon a call of save' do
        expect(faraday).to receive(request_method).and_call_original

        expect(subject.save).to be(subject)
      end

      it 'Reads the answer from the POST' do
        expect(faraday).to receive(request_method).and_call_original

        subject.save

        expect(subject.id).to be(1)
        expect(subject.description).to eq(expected_description)
      end
    end
  end
end
