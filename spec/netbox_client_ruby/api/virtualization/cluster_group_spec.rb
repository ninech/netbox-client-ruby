# frozen_string_literal: true

require 'spec_helper'

RSpec.describe NetboxClientRuby::Virtualization::ClusterGroup, faraday_stub: true do
  subject { described_class.new entity_id }

  let(:entity_id) { 1 }
  let(:expected_name) { '1' }
  let(:base_url) { '/api/virtualization/cluster-groups/' }
  let(:response) { File.read("spec/fixtures/virtualization/cluster-group_#{entity_id}.json") }

  let(:request_url) { "#{base_url}#{entity_id}.json" }

  describe '#id' do
    it 'shall be the expected id' do
      expect(subject.id).to eq(entity_id)
    end
  end

  describe '#name' do
    it 'fetches the data' do
      expect(faraday).to receive(:get).and_call_original

      expect(subject.name).to_not be_nil
    end

    it 'shall be the expected name' do
      expect(subject.name).to eq(expected_name)
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
    let(:request_params) { { 'name' => 'noob' } }

    it 'updates the object' do
      expect(faraday).to receive(request_method).and_call_original
      expect(subject.update(name: 'noob').name).to eq(expected_name)
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
    let(:name) { 'foobar' }
    let(:slug) { '1' }
    let(:request_params) { { 'name' => name, 'slug' => slug } }

    context 'update' do
      subject do
        entity = described_class.new entity_id
        entity.name = name
        entity.slug = slug
        entity
      end

      let(:request_method) { :patch }

      it 'does not call PATCH until save is called' do
        expect(faraday).to_not receive(request_method)
        expect(faraday).to_not receive(:get)

        expect(subject.name).to eq(name)
        expect(subject.slug).to eq(slug)
      end

      it 'calls PATCH when save is called' do
        expect(faraday).to receive(request_method).and_call_original

        expect(subject.save).to be(subject)
      end

      it 'Reads the answer from the PATCH answer' do
        expect(faraday).to receive(request_method).and_call_original

        subject.save
        expect(subject.name).to eq(expected_name)
        expect(subject.slug).to eq(slug)
      end
    end

    context 'create' do
      subject do
        entity = described_class.new
        entity.name = name
        entity.slug = slug
        entity
      end

      let(:request_method) { :post }
      let(:request_url) { base_url }

      it 'does not POST until save is called' do
        expect(faraday).to_not receive(request_method)
        expect(faraday).to_not receive(:get)

        expect(subject.name).to eq(name)
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
        expect(subject.name).to eq(expected_name)
        expect(subject.slug).to eq(slug)
      end
    end
  end
end
