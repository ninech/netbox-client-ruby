# frozen_string_literal: true

require 'spec_helper'

RSpec.describe NetboxClientRuby::DCIM::MacAddress, faraday_stub: true do
  let(:entity_id) { 1 }
  let(:base_url) { '/api/dcim/mac-addresses/' }
  let(:request_url) { "#{base_url}#{entity_id}/" }
  let(:response) { File.read("spec/fixtures/dcim/mac-address_#{entity_id}.json") }

  subject { NetboxClientRuby::DCIM::MacAddress.new entity_id }

  describe '#id' do
    it 'shall be the expected id' do
      expect(subject.id).to eq(entity_id)
    end
  end

  describe '#mac_address' do
    it 'should fetch the data' do
      expect(faraday).to receive(:get).and_call_original

      subject.mac_address
    end

    it 'shall be the expected mac_address' do
      expect(subject.mac_address).to eq('23:2f:bd:ad:aa:d1')
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
    let(:request_params) { { 'mac_address' => '23:2f:bd:ad:aa:d2' } }
    let(:response) { File.read("spec/fixtures/dcim/mac-address_#{entity_id}-update.json") }

    it 'should update the object' do
      expect(faraday).to receive(request_method).and_call_original
      expect(subject.update(mac_address: '23:2f:bd:ad:aa:d2').mac_address).to eq('23:2f:bd:ad:aa:d2')
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
    let(:mac_address) { '23:2f:bd:ad:aa:d2' }
    let(:assigned_object_type) { 'dcim.interface' }
    let(:assigned_object_id) { 2 }
    let(:request_params) do
      {
        'mac_address' => mac_address,
        'assigned_object_type' => assigned_object_type,
        'assigned_object_id' => assigned_object_id
      }
    end

    context 'update' do
      let(:request_method) { :patch }

      subject do
        entity = NetboxClientRuby::DCIM::MacAddress.new entity_id
        entity.mac_address = mac_address
        entity.assigned_object_type = assigned_object_type
        entity.assigned_object_id = assigned_object_id
        entity
      end

      it 'does not call PATCH until save is called' do
        expect(faraday).to_not receive(request_method)
        expect(faraday).to_not receive(:get)

        expect(subject.mac_address).to eq(mac_address)
        expect(subject.assigned_object_type).to eq(assigned_object_type)
        expect(subject.assigned_object_id).to eq(assigned_object_id)
      end

      it 'calls PATCH when save is called' do
        expect(faraday).to receive(request_method).and_call_original

        expect(subject.save).to be(subject)
      end

      it 'Reads the answer from the PATCH answer' do
        expect(faraday).to receive(request_method).and_call_original

        subject.save
        expect(subject.mac_address).to eq('23:2f:bd:ad:aa:d1')
        expect(subject.assigned_object_type).to eq('dcim.interface')
        expect(subject.assigned_object_id).to eq(1)
      end
    end

    context 'create' do
      let(:request_method) { :post }
      let(:request_url) { base_url }

      subject do
        entity = NetboxClientRuby::DCIM::MacAddress.new
        entity.mac_address = mac_address
        entity.assigned_object_type = assigned_object_type
        entity.assigned_object_id = assigned_object_id
        entity
      end

      it 'does not POST until save is called' do
        expect(faraday).to_not receive(request_method)
        expect(faraday).to_not receive(:get)

        expect(subject.mac_address).to eq(mac_address)
        expect(subject.assigned_object_type).to eq(assigned_object_type)
        expect(subject.assigned_object_id).to eq(assigned_object_id)
      end

      it 'POSTs the data upon a call of save' do
        expect(faraday).to receive(request_method).and_call_original

        expect(subject.save).to be(subject)
      end

      it 'Reads the answer from the POST' do
        expect(faraday).to receive(request_method).and_call_original

        subject.save

        expect(subject.id).to be(1)
        expect(subject.mac_address).to eq('23:2f:bd:ad:aa:d1')
        expect(subject.assigned_object_type).to eq('dcim.interface')
        expect(subject.assigned_object_id).to eq(1)
      end
    end
  end
end
