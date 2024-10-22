# frozen_string_literal: true

require 'spec_helper'

RSpec.describe NetboxClientRuby::IPAM::Aggregate, faraday_stub: true do
  let(:class_under_test) { NetboxClientRuby::IPAM::Aggregate }
  let(:base_url) { '/api/ipam/aggregates/' }
  let(:response) { File.read("spec/fixtures/ipam/aggregate_#{entity_id}.json") }

  let(:expected_prefix) { '10.0.0.0/8' }
  let(:entity_id) { 1 }
  let(:request_url) { "#{base_url}#{entity_id}.json" }

  subject { class_under_test.new entity_id }

  describe '#id' do
    it 'shall be the expected id' do
      expect(subject.id).to eq(entity_id)
    end
  end

  describe '#prefix' do
    it 'should fetch the data' do
      expect(faraday).to receive(:get).and_call_original

      expect(subject.prefix).to_not be_nil
    end

    it 'shall be the expected name' do
      expect(subject.prefix).to eq(expected_prefix)
    end
  end

  describe '.rir' do
    context 'entity with rir' do
      it 'should fetch the data' do
        expect(faraday).to receive(:get).and_call_original

        expect(subject.rir).to_not be_nil
      end

      it 'shall return the expected type' do
        expect(subject.rir).to be_a(NetboxClientRuby::IPAM::Rir)
      end

      it 'should an entity with the right it' do
        expect(subject.rir.id).to eq(entity_id)
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
    let(:request_params) { { 'prefix' => '192.168.0.0/16' } }

    it 'should update the object' do
      expect(faraday).to receive(request_method).and_call_original
      expect(subject.update(prefix: '192.168.0.0/16').prefix).to eq(expected_prefix)
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
    let(:prefix) { '192.168.0.0/16' }
    let(:request_params) { { 'prefix' => prefix } }

    context 'update' do
      let(:request_method) { :patch }

      subject do
        entity = class_under_test.new entity_id
        entity.prefix = prefix
        entity
      end

      it 'does not call PATCH until save is called' do
        expect(faraday).to_not receive(request_method)
        expect(faraday).to_not receive(:get)

        expect(subject.prefix).to eq(prefix)
      end

      it 'calls PATCH when save is called' do
        expect(faraday).to receive(request_method).and_call_original

        expect(subject.save).to be(subject)
      end

      it 'Reads the answer from the PATCH answer' do
        expect(faraday).to receive(request_method).and_call_original

        subject.save
        expect(subject.prefix).to eq(expected_prefix)
      end
    end

    context '.new' do
      let(:request_method) { :post }
      let(:request_url) { base_url }

      subject do
        entity = class_under_test.new
        entity.prefix = prefix
        entity
      end

      it 'does not POST until save is called' do
        expect(faraday).to_not receive(request_method)
        expect(faraday).to_not receive(:get)

        expect(subject.prefix).to eq(prefix)
      end

      it 'POSTs the data upon a call of save' do
        expect(faraday).to receive(request_method).and_call_original

        expect(subject.save).to be(subject)
      end

      it 'Reads the answer from the POST' do
        expect(faraday).to receive(request_method).and_call_original

        subject.save

        expect(subject.id).to be(1)
        expect(subject.prefix).to eq(expected_prefix)
      end
    end
  end
end
