# frozen_string_literal: true

require 'spec_helper'
require 'ipaddress'

RSpec.describe NetboxClientRuby::IPAM::IpRange, faraday_stub: true do
  let(:class_under_test) { NetboxClientRuby::IPAM::IpRange }
  let(:base_url) { '/api/ipam/ip-ranges/' }
  let(:response) { File.read("spec/fixtures/ipam/ip-range_#{entity_id}.json") }

  let(:expected_start_address) { IPAddress.parse '10.2.0.10/16' }
  let(:expected_end_address) { IPAddress.parse '10.2.0.20/16' }
  let(:entity_id) { 3 }
  let(:request_url) { "#{base_url}#{entity_id}/" }

  subject { class_under_test.new entity_id }

  describe '#id' do
    it 'shall be the expected id' do
      expect(subject.id).to eq(entity_id)
    end
  end

  describe '#start_address' do
    it 'should fetch the data' do
      expect(faraday).to receive(:get).and_call_original

      subject.start_address
    end

    it 'shall be the expected start_address' do
      expect(subject.start_address).to eq(expected_start_address)
    end
  end

  describe '#end_address' do
    it 'should fetch the data' do
      expect(faraday).to receive(:get).and_call_original

      subject.end_address
    end

    it 'shall be the expected end_address' do
      expect(subject.end_address).to eq(expected_end_address)
    end
  end

  {
    vrf: NetboxClientRuby::IPAM::Vrf,
    tenant: NetboxClientRuby::Tenancy::Tenant,
    status: NetboxClientRuby::IPAM::IpRangeStatus,
    role: NetboxClientRuby::IPAM::Role,
    start_address: IPAddress,
    end_address: IPAddress
  }.each_pair do |method_name, expected_type|
    context 'entity with references' do
      describe ".#{method_name}" do
        it 'should fetch the data and not return nil' do
          expect(faraday).to receive(:get).and_call_original

          expect(subject.public_send(method_name)).to_not be_nil
        end

        it 'shall return the expected type' do
          expect(subject.public_send(method_name)).to be_a(expected_type)
        end
      end
    end

    context 'entity without references' do
      describe ".#{method_name}" do
        it 'should fetch the data and return nil' do
          expect(faraday).to receive(:get).and_call_original

          expect(subject.public_send(method_name)).to be
        end

        it 'shall return the expected type' do
          expect(subject.public_send(method_name)).to be_a(expected_type)
        end
      end
    end
  end

  describe '.status' do
    it 'should assign the correct value' do
      expect(subject.status.label).to eq('Active')
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
    let(:start_address) { IPAddress.parse '192.168.0.10/16' }
    let(:request_method) { :patch }
    let(:request_params) { { 'start_address' => start_address } }

    it 'should update the object' do
      expect(faraday).to receive(request_method).and_call_original
      expect(subject.update(start_address: start_address).start_address).to eq(expected_start_address)
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
    let(:start_address) { '192.168.0.10/16' }
    let(:request_params) { { 'start_address' => start_address } }

    context 'update' do
      let(:request_method) { :patch }

      subject do
        entity = class_under_test.new entity_id
        entity.start_address = start_address
        entity
      end

      it 'does not call PATCH until save is called' do
        expect(faraday).to_not receive(request_method)
        expect(faraday).to_not receive(:get)

        expect(subject.start_address).to eq(start_address)
      end

      it 'calls PATCH when save is called' do
        expect(faraday).to receive(request_method).and_call_original

        expect(subject.save).to be(subject)
      end

      it 'Reads the answer from the PATCH answer' do
        expect(faraday).to receive(request_method).and_call_original

        subject.save
        expect(subject.start_address).to eq(expected_start_address)
      end
    end

    context '.new' do
      let(:request_method) { :post }
      let(:request_url) { base_url }

      subject do
        entity = class_under_test.new
        entity.start_address = start_address
        entity
      end

      it 'does not POST until save is called' do
        expect(faraday).to_not receive(request_method)
        expect(faraday).to_not receive(:get)

        expect(subject.start_address).to eq(start_address)
      end

      it 'POSTs the data upon a call of save' do
        expect(faraday).to receive(request_method).and_call_original

        expect(subject.save).to be(subject)
      end

      it 'Reads the answer from the POST' do
        expect(faraday).to receive(request_method).and_call_original

        subject.save

        expect(subject.id).to be(entity_id)
        expect(subject.start_address).to eq(expected_start_address)
      end
    end
  end
end
