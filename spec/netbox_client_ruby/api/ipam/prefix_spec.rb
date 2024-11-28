# frozen_string_literal: true

require 'spec_helper'
require 'ipaddress'

RSpec.describe NetboxClientRuby::IPAM::Prefix, faraday_stub: true do
  let(:class_under_test) { NetboxClientRuby::IPAM::Prefix }
  let(:base_url) { '/api/ipam/prefixes/' }
  let(:response) { File.read("spec/fixtures/ipam/prefix_#{entity_id}.json") }

  let(:expected_prefix) { IPAddress.parse '10.2.0.0/16' }
  let(:entity_id) { 3 }
  let(:request_url) { "#{base_url}#{entity_id}/" }

  subject { class_under_test.new entity_id }

  describe '#id' do
    it 'shall be the expected id' do
      expect(subject.id).to eq(entity_id)
    end
  end

  describe '#prefix' do
    it 'should fetch the data' do
      expect(faraday).to receive(:get).and_call_original

      subject.prefix
    end

    it 'shall be the expected prefix' do
      expect(subject.prefix).to eq(expected_prefix)
    end
  end

  {
    site: NetboxClientRuby::DCIM::Site,
    vrf: NetboxClientRuby::IPAM::Vrf,
    tenant: NetboxClientRuby::Tenancy::Tenant,
    vlan: NetboxClientRuby::IPAM::Vlan,
    status: NetboxClientRuby::IPAM::PrefixStatus,
    role: NetboxClientRuby::IPAM::Role,
    prefix: IPAddress
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
      expect(subject.status.label).to eq('Container')
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
    let(:prefix) { IPAddress.parse '192.168.0.0/16' }
    let(:request_method) { :patch }
    let(:request_params) { { 'prefix' => prefix } }

    it 'should update the object' do
      expect(faraday).to receive(request_method).and_call_original
      expect(subject.update(prefix: prefix).prefix).to eq(expected_prefix)
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

        expect(subject.id).to be(entity_id)
        expect(subject.prefix).to eq(expected_prefix)
      end
    end
  end
end
