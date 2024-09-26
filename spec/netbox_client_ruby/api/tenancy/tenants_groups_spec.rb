# frozen_string_literal: true

require 'spec_helper'

RSpec.describe NetboxClientRuby::Tenancy::TenantGroups, faraday_stub: true do
  let(:expected_number_of_items) { 1 }
  let(:expected_singular_type) { NetboxClientRuby::Tenancy::TenantGroup }

  let(:response) { File.read('spec/fixtures/tenancy/tenant-groups.json') }
  let(:request_url) { '/api/tenancy/tenant-groups/' }
  let(:request_url_params) do
    { limit: NetboxClientRuby.config.netbox.pagination.default_limit }
  end

  context 'unpaged fetch' do
    describe '#length' do
      it 'shall be the expected length' do
        expect(subject.length).to be expected_number_of_items
      end
    end

    describe '#total' do
      it 'shall be the expected total' do
        expect(subject.total).to be expected_number_of_items
      end
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
    it 'return the correct amount' do
      expect(subject.to_a.length).to be expected_number_of_items
    end

    it 'returns single instances' do
      subject.to_a.each do |element|
        expect(element).to be_a expected_singular_type
      end
    end
  end
end
