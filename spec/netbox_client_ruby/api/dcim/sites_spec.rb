# frozen_string_literal: true

require 'spec_helper'

RSpec.describe NetboxClientRuby::DCIM::Sites, faraday_stub: true do
  let(:response) { File.read('spec/fixtures/dcim/sites.json') }
  let(:request_url) { '/api/dcim/sites/' }
  let(:request_url_params) do
    { limit: NetboxClientRuby.config.netbox.pagination.default_limit }
  end

  subject { NetboxClientRuby::DCIM::Sites.new }

  context 'unpaged fetch' do
    describe '#length' do
      it 'shall be the expected length' do
        expect(subject.length).to be 2
      end
    end

    describe '#total' do
      it 'shall be the expected total' do
        expect(subject.total).to be 2
      end
    end
  end

  context 'paged fetch' do
    let(:response) { File.read('spec/fixtures/dcim/sites_with_next.json') }

    describe '#length' do
      it 'shall be the expected length' do
        expect(subject.length).to be 1
      end
    end

    describe '#total' do
      it 'shall be the expected total' do
        expect(subject.total).to be 2
      end
    end

    describe '#all' do
      let(:request_url_params) do
        { limit: NetboxClientRuby.config.netbox.pagination.max_limit }
      end

      it 'shall fetch and return all entities' do
        expect(subject.all.total).to be 2
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
      expect(subject.to_a.length).to be 2
    end

    it 'returns Site instances' do
      subject.to_a.each do |element|
        expect(element).to be_a NetboxClientRuby::DCIM::Site
      end
    end
  end
end
