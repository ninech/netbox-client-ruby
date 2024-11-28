# frozen_string_literal: true

require 'spec_helper'

RSpec.describe NetboxClientRuby::DCIM::Region, faraday_stub: true do
  let(:region_id) { 1 }
  let(:response) { File.read("spec/fixtures/dcim/region_#{region_id}.json") }
  let(:request_url) { "/api/dcim/regions/#{region_id}/" }

  subject { NetboxClientRuby::DCIM::Region.new region_id }

  describe '#id' do
    it 'shall be the expected id' do
      expect(subject.id).to eq(region_id)
    end
  end

  describe '#name' do
    it 'should fetch the data' do
      expect(faraday).to receive(:get).and_call_original

      subject.name
    end

    it 'shall be the expected name' do
      expect(subject.name).to eq('region1')
    end
  end

  describe '.parent' do
    it 'should be nil' do
      expect(subject.parent).to be_nil
    end

    context 'Sub Region' do
      let(:region_id) { 2 }

      it 'should be a Region object' do
        parent_region = subject.parent
        expect(parent_region).to be_a NetboxClientRuby::DCIM::Region
        expect(parent_region.id).to eq(1)
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
      expect(subject.update(name: 'noob').name).to eq('region1')
    end

    context 'Sub Region' do
      let(:region_id) { 2 }

      context 'delete a parent' do
        let(:request_params) { { 'parent' => nil } }

        it 'should remove the parent' do
          expect(subject.update(parent: nil)).to be subject
        end
      end

      context 'add a parent' do
        let(:request_params) { { 'parent' => 1 } }

        it 'should add a parent' do
          expect(subject.update(parent: 1)).to be subject
        end
      end
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
    let(:slug) { name }
    let(:request_params) { { 'name' => name, 'slug' => slug } }

    context 'update' do
      let(:request_method) { :patch }

      subject do
        region = NetboxClientRuby::DCIM::Region.new region_id
        region.name = name
        region.slug = slug
        region
      end

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
        expect(subject.name).to eq('region1')
        expect(subject.slug).to eq('region1')
      end
    end

    context 'create' do
      let(:request_method) { :post }
      let(:request_url) { '/api/dcim/regions/' }

      subject do
        region = NetboxClientRuby::DCIM::Region.new
        region.name = name
        region.slug = slug
        region
      end

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
        expect(subject.name).to eq('region1')
        expect(subject.slug).to eq('region1')
      end
    end
  end
end
