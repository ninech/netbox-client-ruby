# frozen_string_literal: true

require 'spec_helper'

# Exercises Exigence A (bulk create / update / delete with full-object return
# and typed per-element 400 errors) through a real collection: dcim.cables.
RSpec.describe NetboxClientRuby::BulkOperations, faraday_stub: true do
  subject(:cables) { NetboxClientRuby.dcim.cables }

  let(:request_url) { '/api/dcim/cables/' }

  describe '#bulk_create' do
    let(:request_method) { :post }
    let(:request_params) { [{ 'label' => 'A' }, { 'label' => 'B' }] }
    let(:response_status) { 201 }
    let(:response) { File.read('spec/fixtures/dcim/cables_bulk_create.json') }

    it 'returns the full objects as entities' do
      result = cables.bulk_create([{ 'label' => 'A' }, { 'label' => 'B' }])

      expect(result).to all(be_a(NetboxClientRuby::DCIM::Cable))
    end

    it 'exposes the ids assigned by NetBox' do
      result = cables.bulk_create([{ 'label' => 'A' }, { 'label' => 'B' }])

      expect(result.map(&:id)).to eq([101, 102])
    end

    it 'preserves the full payload of each created object' do
      result = cables.bulk_create([{ 'label' => 'A' }, { 'label' => 'B' }])

      expect(result.first.raw_data!['label']).to eq('A')
    end
  end

  describe '#bulk_update' do
    let(:request_method) { :patch }
    let(:request_params) { [{ 'id' => 101, 'label' => 'A2' }, { 'id' => 102, 'label' => 'B2' }] }
    let(:response) { File.read('spec/fixtures/dcim/cables_bulk_update.json') }

    it 'returns the updated objects' do
      result = cables.bulk_update([{ 'id' => 101, 'label' => 'A2' }, { 'id' => 102, 'label' => 'B2' }])

      expect(result.map(&:id)).to eq([101, 102])
    end

    it 'raises a LocalError when an element is missing its id' do
      expect do
        cables.bulk_update([{ 'label' => 'no-id' }])
      end.to raise_error(NetboxClientRuby::LocalError, /missing an 'id'/)
    end
  end

  describe '#bulk_delete' do
    let(:request_method) { :delete }
    let(:request_params) { [{ id: 101 }, { id: 102 }] }
    let(:response_status) { 204 }
    let(:response) { nil }

    it 'normalizes ids/hashes/entities into an [{id:}] body and returns the count' do
      deleted = cables.bulk_delete([101, { 'id' => 102 }])

      expect(deleted).to eq(2)
    end
  end

  describe 'typed per-element 400 errors' do
    let(:request_method) { :post }
    let(:request_params) { [{ 'a' => 1 }, { 'a' => 2 }, { 'a' => 3 }] }
    let(:response_status) { 400 }
    let(:response) { File.read('spec/fixtures/dcim/cables_bulk_errors.json') }

    it 'raises a BulkError that surfaces only the rejected elements' do
      expect do
        cables.bulk_create([{ 'a' => 1 }, { 'a' => 2 }, { 'a' => 3 }])
      end.to raise_error(NetboxClientRuby::BulkError) do |error|
        expect(error.failures.length).to eq(1)
        expect(error.failures.first[:index]).to eq(1)
        expect(error.failures.first[:item]).to eq({ 'a' => 2 })
        expect(error.failures.first[:errors]['type']).to include(/may not be blank/)
        expect(error.total_failure?).to be(false)
      end
    end
  end
end
