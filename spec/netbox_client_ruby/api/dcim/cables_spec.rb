# frozen_string_literal: true

require 'spec_helper'

RSpec.describe NetboxClientRuby::DCIM::Cables, faraday_stub: true do
  let(:expected_length) { 3 }
  let(:singular_type) { NetboxClientRuby::DCIM::Cable }

  let(:response) { File.read('spec/fixtures/dcim/cables.json') }
  let(:request_url) { '/api/dcim/cables/' }

  context 'unpaged fetch' do
    describe '#length' do
      it 'shall be the expected length' do
        expect(subject.length).to be expected_length
      end
    end

    describe '#total' do
      it 'shall be the expected total' do
        expect(subject.total).to be expected_length
      end
    end

    describe '#reload' do
      it 'fetches the correct data' do
        expect(faraday).to receive(:get).and_call_original
        subject.reload
      end

      it 'caches the data' do
        expect(faraday).to receive(:get).and_call_original
        subject.total
        subject.total
      end

      it 'reloads the data' do
        expect(faraday).to receive(:get).twice.and_call_original
        subject.reload
        subject.reload
      end
    end

    describe '#as_array' do
      it 'returns the correct amount' do
        expect(subject.to_a.length).to be expected_length
      end

      it 'returns Cable instances' do
        subject.to_a.each do |element|
          expect(element).to be_a singular_type
        end
      end
    end
  end
end
