require 'spec_helper'

describe NetboxClientRuby::Site, faraday_stub: true do
  let(:site_id) { 1 }
  let(:response) { File.read('spec/fixtures/dcim/site.json') }
  let(:request_url) { "/api/dcim/sites/#{site_id}.json" }

  subject { NetboxClientRuby::Site.new site_id }

  describe '#id' do
    it 'shall be the expected id' do
      expect(subject.id).to eq(site_id)
    end
  end

  describe '#name' do
    it 'should fetch the data' do
      expect(faraday).to receive(:get).and_call_original

      subject.name
    end

    it 'shall be the expected name' do
      expect(subject.name).to eq('test')
    end
  end

  describe '#count_prefixes' do
    it 'should have the expected value' do
      expect(subject.count_prefixes).to eq(0)
    end

    it 'should not be updateable' do
      expect { subject.count_prefixes = 2 }.to raise_exception(NoMethodError)
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
      expect(subject.update(name: 'noob').name).to eq('test')
    end
  end

  describe '.reload' do
    it 'should reload the object' do
      expect(faraday).to receive(request_method).twice.and_call_original

      subject.reload
      subject.reload
    end
  end
end
