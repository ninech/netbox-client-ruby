# frozen_string_literal: true

require 'spec_helper'

RSpec.describe NetboxClientRuby::DCIM::Device, faraday_stub: true do
  let(:entity_id) { 2 }
  let(:expected_name) { 'device2' }
  let(:sut) { NetboxClientRuby::DCIM::Device }
  let(:base_url) { '/api/dcim/devices/' }
  let(:response) { File.read("spec/fixtures/dcim/device_#{entity_id}.json") }

  let(:request_url) { "#{base_url}#{entity_id}.json" }

  subject { sut.new entity_id }

  describe '#id' do
    it 'shall be the expected id' do
      expect(subject.id).to eq(entity_id)
    end
  end

  describe '#name' do
    it 'should fetch the data' do
      expect(faraday).to receive(:get).and_call_original

      expect(subject.name).to_not be_nil
    end

    it 'shall be the expected name' do
      expect(subject.name).to eq(expected_name)
    end
  end

  {
    device_type: [NetboxClientRuby::DCIM::DeviceType, 1],
    device_role: [NetboxClientRuby::DCIM::DeviceRole, 1],
    tenant: [NetboxClientRuby::Tenancy::Tenant, 3],
    platform: [NetboxClientRuby::DCIM::Platform, 1],
    site: [NetboxClientRuby::DCIM::Site, 2],
    rack: [NetboxClientRuby::DCIM::Rack, 1],
    primary_ip: [NetboxClientRuby::IPAM::IpAddress, 5],
    primary_ip4: [NetboxClientRuby::IPAM::IpAddress, 1],
    primary_ip6: [NetboxClientRuby::IPAM::IpAddress, 5]
  }.each do |method_name, expected_values|
    expected_type = expected_values[0]
    expected_id = expected_values[1]

    describe "##{method_name}" do
      it "should return a #{expected_type}" do
        expect(subject.public_send(method_name))
          .to be_a(expected_type)
      end

      it "should be the expected #{method_name}" do
        expect(subject.public_send(method_name).id).to eq(expected_id)
      end
    end
  end

  describe "#tags" do
    it "should return an Array" do
      expect(subject.tags)
        .to be_a(Array)
    end

    it "should have NetboxClientRuby::Extras::Tag as elements" do
      expect(subject.tags[0])
        .to be_a(NetboxClientRuby::Extras::Tag)
    end

    it "should be the expected tag" do
      expect(subject.tags[0].id).to eq(1)
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
      expect(subject.update(name: 'noob').name).to eq(expected_name)
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
    let(:display_name) { name }
    let(:request_params) { { 'name' => name, 'display_name' => display_name } }

    context 'update' do
      let(:request_method) { :patch }

      subject do
        region = sut.new entity_id
        region.name = name
        region.display_name = display_name
        region
      end

      it 'does not call PATCH until save is called' do
        expect(faraday).to_not receive(request_method)
        expect(faraday).to_not receive(:get)

        expect(subject.name).to eq(name)
        expect(subject.display_name).to eq(display_name)
      end

      it 'calls PATCH when save is called' do
        expect(faraday).to receive(request_method).and_call_original

        expect(subject.save).to be(subject)
      end

      it 'Reads the answer from the PATCH answer' do
        expect(faraday).to receive(request_method).and_call_original

        subject.save
        expect(subject.name).to eq(expected_name)
        expect(subject.display_name).to eq(expected_name)
      end
    end

    context 'create' do
      let(:request_method) { :post }
      let(:request_url) { base_url }

      subject do
        region = sut.new
        region.name = name
        region.display_name = display_name
        region
      end

      it 'does not POST until save is called' do
        expect(faraday).to_not receive(request_method)
        expect(faraday).to_not receive(:get)

        expect(subject.name).to eq(name)
        expect(subject.display_name).to eq(display_name)
      end

      it 'POSTs the data upon a call of save' do
        expect(faraday).to receive(request_method).and_call_original

        expect(subject.save).to be(subject)
      end

      it 'Reads the answer from the POST' do
        expect(faraday).to receive(request_method).and_call_original

        subject.save

        expect(subject.id).to eq(entity_id)
        expect(subject.name).to eq(expected_name)
        expect(subject.display_name).to eq(expected_name)
      end
    end
  end
end
