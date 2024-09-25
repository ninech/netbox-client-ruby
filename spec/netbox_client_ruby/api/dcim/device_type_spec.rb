# frozen_string_literal: true

require 'spec_helper'

RSpec.describe NetboxClientRuby::DCIM::DeviceType, faraday_stub: true do
  let(:entity_id) { 1 }
  let(:expected_model) { 'devicetype1' }
  let(:sut) { NetboxClientRuby::DCIM::DeviceType }
  let(:base_url) { '/api/dcim/device-types/' }

  let(:request_url) { "#{base_url}#{entity_id}.json" }
  let(:response) { File.read("spec/fixtures/dcim/device-type_#{entity_id}.json") }

  subject { sut.new entity_id }

  describe '#id' do
    it 'shall be the expected id' do
      expect(subject.id).to eq(entity_id)
    end
  end

  describe '#model' do
    it 'should fetch the data' do
      expect(faraday).to receive(:get).and_call_original

      expect(subject.model).to_not be_nil
    end

    it 'shall be the expected model' do
      expect(subject.model).to eq(expected_model)
    end
  end

  describe '#manufacturer' do
    it 'should return a Manufacturer' do
      expect(subject.manufacturer).to be_a(NetboxClientRuby::DCIM::Manufacturer)
    end

    it 'should be the expected manufacturer' do
      expect(subject.manufacturer.id).to be(1)
    end
  end

  describe '#interface_ordering' do
    it 'should return a InterfaceOrdering' do
      expect(subject.interface_ordering).to be_a(NetboxClientRuby::DCIM::InterfaceOrdering)
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
    let(:request_params) { { 'model' => 'noob' } }

    it 'should update the object' do
      expect(faraday).to receive(request_method).and_call_original
      expect(subject.update(model: 'noob').model).to eq(expected_model)
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
    let(:model) { 'foobar' }
    let(:slug) { model }
    let(:request_params) { { 'model' => model, 'slug' => slug } }

    context 'update' do
      let(:request_method) { :patch }

      subject do
        region = sut.new entity_id
        region.model = model
        region.slug = slug
        region
      end

      it 'does not call PATCH until save is called' do
        expect(faraday).to_not receive(request_method)
        expect(faraday).to_not receive(:get)

        expect(subject.model).to eq(model)
        expect(subject.slug).to eq(slug)
      end

      it 'calls PATCH when save is called' do
        expect(faraday).to receive(request_method).and_call_original

        expect(subject.save).to be(subject)
      end

      it 'Reads the answer from the PATCH answer' do
        expect(faraday).to receive(request_method).and_call_original

        subject.save
        expect(subject.model).to eq(expected_model)
        expect(subject.slug).to eq(expected_model)
      end
    end

    context 'create' do
      let(:request_method) { :post }
      let(:request_url) { base_url }

      subject do
        region = sut.new
        region.model = model
        region.slug = slug
        region
      end

      it 'does not POST until save is called' do
        expect(faraday).to_not receive(request_method)
        expect(faraday).to_not receive(:get)

        expect(subject.model).to eq(model)
        expect(subject.slug).to eq(slug)
      end

      it 'POSTs the data upon a call of save' do
        expect(faraday).to receive(request_method).and_call_original

        expect(subject.save).to be(subject)
      end

      it 'Reads the answer from the POST' do
        expect(faraday).to receive(request_method).and_call_original

        subject.save

        expect(subject.id).to be(1)
        expect(subject.model).to eq(expected_model)
        expect(subject.slug).to eq(expected_model)
      end
    end
  end
end
