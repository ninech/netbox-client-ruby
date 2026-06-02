# frozen_string_literal: true

require 'spec_helper'

# Exercises Exigence B (filterable/paginated get_list + multi-page aggregation)
# against /api/core/object-changes/ — the incremental polling source.
RSpec.describe NetboxClientRuby::Core::ObjectChanges, faraday_stub: true do
  subject(:object_changes) { NetboxClientRuby.core.object_changes }

  let(:request_url) { '/api/core/object-changes/' }
  let(:response) { File.read('spec/fixtures/core/object-changes.json') }

  describe 'single-page get_list' do
    let(:expected_length) { 2 }

    it 'fetches the change records' do
      expect(object_changes.length).to be expected_length
    end

    it 'wraps them as ObjectChange entities' do
      expect(object_changes.to_a).to all(be_a(NetboxClientRuby::Core::ObjectChange))
    end

    it 'exposes raw results and pagination cursors' do
      expect(object_changes.results.length).to eq(2)
      expect(object_changes.next_url).to be_nil
      expect(object_changes.previous_url).to be_nil
    end
  end

  describe 'filterable get_list (multi changed_object_type_id, time_after, ordering)' do
    let(:request_url_params) do
      { changed_object_type_id: [12, 34], time_after: '2026-06-01T00:00:00Z', ordering: '-time', limit: 100 }
    end

    it 'encodes repeated changed_object_type_id and the extra filters' do
      result = object_changes.get_list(
        { changed_object_type_id: [12, 34], time_after: '2026-06-01T00:00:00Z', ordering: '-time' },
        limit: 100
      )

      expect(result.length).to eq(2)
    end
  end

  describe '#all_pages across multiple pages' do
    let(:response) { File.read('spec/fixtures/core/object-changes_page1.json') }

    before do
      page2 = File.read('spec/fixtures/core/object-changes_page2.json')
      faraday_stubs.get('/api/core/object-changes/?limit=2&offset=2') do |_env|
        [200, { content_type: 'application/json' }, page2]
      end
    end

    it 'follows next and aggregates every record across pages' do
      all = object_changes.all_pages

      expect(all.map(&:id)).to eq([1, 2, 3])
    end

    it 'returns ObjectChange entities' do
      expect(object_changes.all_pages).to all(be_a(NetboxClientRuby::Core::ObjectChange))
    end
  end
end
