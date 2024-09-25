# frozen_string_literal: true

require 'spec_helper'

RSpec.describe NetboxClientRuby::Circuits::CircuitTermination, faraday_stub: true do
  let(:id) { 1 }
  let(:base_url) { '/api/circuits/circuit-terminations/' }
  let(:request_url) { "#{base_url}#{id}.json" }
  let(:response) { File.read("spec/fixtures/circuits/circuit-termination_#{id}.json") }

  subject { described_class.new id }

  describe '#id' do
    it 'shall be the expected id' do
      expect(subject.id).to eq(id)
    end
  end

  describe '#term_side' do
    it 'should fetch the data' do
      expect(faraday).to receive(:get).and_call_original

      subject.term_side
    end

    it 'shall be the expected term_side' do
      expect(subject.term_side).to eq('A')
    end
  end

  describe '.site' do
    it 'should be a Site object' do
      site = subject.site
      expect(site).to be_a NetboxClientRuby::DCIM::Site
      expect(site.id).to eq(1)
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
    let(:request_params) { { 'term_side' => 'noob' } }

    it 'should update the object' do
      expect(faraday).to receive(request_method).and_call_original
      expect(subject.update(term_side: 'noob').term_side).to eq('A')
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
    let(:term_side) { 'Z' }
    let(:request_params) { { 'term_side' => term_side } }

    context 'update' do
      let(:request_method) { :patch }

      subject do
        entity = described_class.new id
        entity.term_side = term_side
        entity
      end

      it 'does not call PATCH until save is called' do
        expect(faraday).to_not receive(request_method)
        expect(faraday).to_not receive(:get)

        expect(subject.term_side).to eq(term_side)
      end

      it 'calls PATCH when save is called' do
        expect(faraday).to receive(request_method).and_call_original

        expect(subject.save).to be(subject)
      end

      it 'Reads the answer from the PATCH answer' do
        expect(faraday).to receive(request_method).and_call_original

        subject.save
        expect(subject.term_side).to eq('A')
      end
    end

    context 'create' do
      let(:request_method) { :post }
      let(:request_url) { base_url }

      subject do
        entity = described_class.new
        entity.term_side = term_side
        entity
      end

      it 'does not POST until save is called' do
        expect(faraday).to_not receive(request_method)
        expect(faraday).to_not receive(:get)

        expect(subject.term_side).to eq(term_side)
      end

      it 'POSTs the data upon a call of save' do
        expect(faraday).to receive(request_method).and_call_original

        expect(subject.save).to be(subject)
      end

      it 'Reads the answer from the POST' do
        expect(faraday).to receive(request_method).and_call_original

        subject.save

        expect(subject.id).to be(1)
        expect(subject.term_side).to eq('A')
      end
    end
  end
end
