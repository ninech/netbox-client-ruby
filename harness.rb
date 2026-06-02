# frozen_string_literal: true

# Runtime proof of the new logic WITHOUT the gem's external dependencies
# (faraday / dry-configurable / zeitwerk). We load the real source files and
# drive them with fake Faraday-style responses.

GEM = File.expand_path('lib/netbox_client_ruby', __dir__)
require "#{GEM}/error"
require "#{GEM}/communication"
require "#{GEM}/bulk_operations"
require "#{GEM}/entities"

# Minimal stand-in for NetboxClientRuby.config (real gem uses dry-configurable).
Pagination = Struct.new(:default_limit, :max_limit)
Netbox = Struct.new(:pagination)
Config = Struct.new(:netbox)
module NetboxClientRuby
  def self.config
    @config ||= Config.new(Netbox.new(Pagination.new(50, 1000)))
  end
end

# --- Fakes -------------------------------------------------------------------
FakeResponse = Struct.new(:status, :body)

class FakeFaraday
  attr_reader :calls

  def initialize(script)
    @script = script        # Hash: [method, path] => FakeResponse
    @calls = []
  end

  def post(path, body = nil)
    record(:post, path, body)
  end

  def patch(path, body = nil)
    record(:patch, path, body)
  end

  def delete(path)
    req = Object.new
    captured = nil
    req.define_singleton_method(:body=) { |b| captured = b }
    yield req if block_given?
    record(:delete, path, captured)
  end

  def get(path)
    record(:get, path, nil)
  end

  private

  def record(method, path, body)
    @calls << { method: method, path: path, body: body }
    @script[[method, path]] || FakeResponse.new(200, [])
  end
end

class FakeEntity
  attr_accessor :data

  def initialize(id) = (@id = id)
  def id = @id
  def raw_data! = data
end

# A collection backed by the REAL Entities + BulkOperations modules.
class FakeCables
  include NetboxClientRuby::Entities

  path 'dcim/cables/'
  data_key 'results'
  count_key 'count'
  entity_creator :entity_creator

  def initialize(faraday)
    @faraday = faraday
  end

  # Override Communication#connection with our fake.
  def connection
    @faraday
  end

  # Allow pre-seeding the first page (bypasses config-dependent #get).
  def seed!(page)
    @data = page
    self
  end

  private

  def entity_creator(raw)
    FakeEntity.new(raw['id'])
  end
end

def assert(label, cond)
  raise "FAILED: #{label}" unless cond

  puts "  ok  #{label}"
end

puts '== Exigence A: bulk_create returns full objects with ids =='
script = {
  [:post, 'dcim/cables/'] => FakeResponse.new(201, [
                                                 { 'id' => 101, 'label' => 'A', 'status' => { 'value' => 'connected' } },
                                                 { 'id' => 102, 'label' => 'B', 'status' => { 'value' => 'connected' } }
                                               ])
}
faraday = FakeFaraday.new(script)
cables = FakeCables.new(faraday)
created = cables.bulk_create([{ label: 'A' }, { label: 'B' }])
assert('POST sent to collection path', faraday.calls.last[:path] == 'dcim/cables/')
assert('request body is an array of 2', faraday.calls.last[:body].length == 2)
assert('returns wrapped entities', created.all? { |c| c.is_a?(FakeEntity) })
assert('ids are recoverable', created.map(&:id) == [101, 102])
assert('full body is preserved', created.first.raw_data!['label'] == 'A')

puts '== Exigence A: bulk_update requires id, sends PATCH =='
script = { [:patch, 'dcim/cables/'] => FakeResponse.new(200, [{ 'id' => 5, 'label' => 'x' }]) }
cables = FakeCables.new(FakeFaraday.new(script))
updated = cables.bulk_update([{ id: 5, label: 'x' }])
assert('returns updated entity', updated.first.id == 5)
begin
  FakeCables.new(FakeFaraday.new({})).bulk_update([{ label: 'no-id' }])
  assert('missing id should raise', false)
rescue NetboxClientRuby::LocalError => e
  assert('missing id raises LocalError', e.message.include?('missing'))
end

puts '== Exigence A: bulk_delete sends [{id:}] body =='
faraday = FakeFaraday.new({ [:delete, 'dcim/cables/'] => FakeResponse.new(204, nil) })
n = FakeCables.new(faraday).bulk_delete([101, { id: 102 }, FakeEntity.new(103)])
assert('DELETE body normalized to id hashes',
       faraday.calls.last[:body] == [{ id: 101 }, { id: 102 }, { id: 103 }])
assert('returns count deleted', n == 3)

puts '== Exigence A: typed per-element 400 errors =='
body400 = [{}, { 'name' => ['This field is required.'] }, {}]
faraday = FakeFaraday.new({ [:post, 'dcim/cables/'] => FakeResponse.new(400, body400) })
begin
  FakeCables.new(faraday).bulk_create([{ a: 1 }, { a: 2 }, { a: 3 }])
  assert('400 should raise', false)
rescue NetboxClientRuby::BulkError => e
  assert('only failed elements surface', e.failures.length == 1)
  assert('failure carries its index', e.failures.first[:index] == 1)
  assert('failure carries submitted item', e.failures.first[:item] == { a: 2 })
  assert('failure carries field errors', e.failures.first[:errors]['name'].first.include?('required'))
  assert('not a total failure', e.total_failure? == false)
end

puts '== Exigence B: get_list exposes results + next_url =='
page1 = {
  'count' => 5, 'next' => 'http://nb/api/core/object-changes/?limit=2&offset=2',
  'previous' => nil,
  'results' => [{ 'id' => 1 }, { 'id' => 2 }]
}
changes = FakeCables.new(FakeFaraday.new({})).seed!(page1)
changes.get_list({ changed_object_type_id: [12, 34], time_after: 't', ordering: '-time' }, limit: 2)
# get_list calls filter/limit which reset @data; re-seed to inspect page accessors:
changes.seed!(page1)
assert('results returns raw page array', changes.results == [{ 'id' => 1 }, { 'id' => 2 }])
assert('next_url exposed', changes.next_url.end_with?('offset=2'))
assert('previous_url nil on first page', changes.previous_url.nil?)

puts '== Exigence B: all_pages follows next across pages =='
page1 = {
  'next' => 'http://nb/api/core/object-changes/?offset=2',
  'results' => [{ 'id' => 1 }, { 'id' => 2 }]
}
page2 = {
  'next' => 'http://nb/api/core/object-changes/?offset=4',
  'results' => [{ 'id' => 3 }, { 'id' => 4 }]
}
page3 = { 'next' => nil, 'results' => [{ 'id' => 5 }] }
faraday = FakeFaraday.new({
                            [:get, 'http://nb/api/core/object-changes/?offset=2'] => FakeResponse.new(200, page2),
                            [:get, 'http://nb/api/core/object-changes/?offset=4'] => FakeResponse.new(200, page3)
                          })
agg = FakeCables.new(faraday).seed!(page1)
all = agg.all_pages
assert('aggregated all 5 across 3 pages', all.map(&:id) == [1, 2, 3, 4, 5])
assert('followed next exactly twice', faraday.calls.count { |c| c[:method] == :get } == 2)

puts "\nALL HARNESS CHECKS PASSED"
