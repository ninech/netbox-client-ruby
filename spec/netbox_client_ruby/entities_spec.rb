require 'spec_helper'
require 'ostruct'

describe NetboxClientRuby::Entities, faraday_stub: true do
  class TestEntities
    include NetboxClientRuby::Entities

    attr_accessor :collected_raw_entities

    path 'tests/42'
    data_key 'data_node'
    count_key 'total_count'
    limit 321
    entity_creator :entity_creator

    private

    def entity_creator(raw_entity)
      OpenStruct.new raw_entity
    end
  end
  class TestEntities2
    include NetboxClientRuby::Entities

    path '/test'
    data_key 'non_existent'
    count_key 'non_existent'
  end
  class TestEntities3
    include NetboxClientRuby::Entities
  end

  let(:raw_data) do
    {
      'total_count' => 999,
      'superfluous_information' => 'blablabla',
      'data_node' => [
        { 'name' => 'obj1' },
        { 'name' => 'obj2' },
        { 'name' => 'obj3' }
      ]
    }
  end
  let(:response) { JSON.generate(raw_data) }
  let(:request_url) { '/api/tests/42' }
  let(:request_url_params) { { limit: 321 } }
  let(:subject) { TestEntities.new }

  describe '#total' do
    it 'returns the correct total' do
      expect(faraday).to receive(:get).and_call_original
      expect(subject.total).to eq 999
    end

    it 'caches the total' do
      expect(faraday).to receive(:get).once.and_call_original
      expect(subject.total).to eq 999
      expect(subject.total).to eq 999
    end

    context 'nonexistent count_key provided' do
      subject { TestEntities2.new }
      let(:request_url) { '/test' }
      let(:request_url_params) do
        { limit: NetboxClientRuby.config.netbox.pagination.default_limit }
      end

      it 'return nil' do
        expect(subject.total).to be_nil
      end
    end
  end

  describe '#length' do
    it 'returns the correct number of fetched data' do
      expect(subject.length).to eq 3
    end
  end

  describe '#reload' do
    it 'fetches the data when asked to' do
      expect(faraday).to receive(:get).twice.and_call_original
      subject.reload
      subject.reload
    end

    it 'returns itself when reloading' do
      expect(subject.reload).to be subject
    end
  end

  describe '#method_missing' do
    it 'raises a NoMethodError when the field is not in the response' do
      expect { subject.nope }.to raise_error NoMethodError
    end
  end

  describe '#as_array' do
    it 'returns an Array' do
      expect(subject.as_array).to be_a Array
      expect(subject.as_array.length).to be 3
    end

    it 'returns the entities as array' do
      subject.as_array.each do |entity|
        expect(entity).to be_a OpenStruct
        expect(entity).to respond_to :data
        expect(entity.data).to be_a Hash
      end
    end

    it 'returns a fresh Array every time' do
      expect(subject.as_array).to_not be subject.as_array
    end
  end

  describe '#[]' do
    it 'returns the requested item as correct type' do
      expect(subject[0]).to be_a OpenStruct
      expect(subject[0]).to respond_to :data
      expect(subject[0].data).to eq 'name' => 'obj1'
    end

    it 'returns nil for out-of-bound requests' do
      expect(subject[1000]).to be_nil
    end
  end

  context 'nonexistent data_key provided' do
    subject { TestEntities2.new }
    let(:request_url) { '/test' }
    let(:request_url_params) do
      { limit: NetboxClientRuby.config.netbox.pagination.default_limit }
    end

    describe '#as_array' do
      it 'returns an empty Array' do
        expect(subject.as_array).to eq []
      end
    end

    describe '#[]' do
      it 'returns an empty Array' do
        expect(subject[0]).to be_nil
      end
    end
  end

  describe '#raw_data' do
    it 'returns the raw data as provided by faraday' do
      expect(subject.raw_data!).to eq raw_data
    end
  end

  describe '#path' do
    context 'a wrong path is given' do
      let(:subject) { TestEntities2.new }

      it 'raises an exception' do
        expect { subject.reload }.to raise_error Faraday::Adapter::Test::Stubs::NotFound
      end
    end

    context 'no path given' do
      let(:subject) { TestEntities3.new }

      it 'raises an exception' do
        expect { subject.reload }.to raise_error ArgumentError
      end
    end
  end

  describe '#filter' do
    let(:filter) { { something: true } }

    it 'returns itself' do
      expect(subject.filter(filter)).to be subject
    end

    it 'does not request anything' do
      expect(faraday).to_not receive(:get)
      subject.filter(filter)
    end

    it 'resets the data' do
      expect(faraday).to receive(:get).twice.and_call_original
      subject.reload.filter(filter).reload
    end

    context 'check filter on connection' do
      let(:request_url_params) { filter }

      it 'applies the filter' do
        subject.filter(filter).reload
      end
    end
  end

  describe '#all' do
    let(:limit) { 1234 }
    let(:request_url_params) { { limit: limit } }

    it 'returns itself' do
      expect(subject.all).to be subject
    end

    it 'fetches all the articles until the maximum allowed value' do
      subject.limit(limit).reload
    end

    context 'limit exactly maximum' do
      let(:limit) do
        NetboxClientRuby.config.netbox.pagination.max_limit
      end

      it 'works as expected' do
        expect { subject.limit(limit) }.to_not raise_exception
      end
    end

    context 'limit higher than maximum' do
      let(:limit) do
        NetboxClientRuby.config.netbox.pagination.max_limit + 1
      end

      it 'raises an ArgumentError' do
        expect { subject.limit(limit) }.to raise_error(ArgumentError)
      end
    end

    context 'limit negative' do
      let(:limit) { -1 }

      it 'raises an ArgumentError' do
        expect { subject.limit(limit) }.to raise_error(ArgumentError)
      end
    end

    context 'limit nil' do
      let(:limit) { nil }

      it 'raises an ArgumentError' do
        expect { subject.limit(limit) }.to raise_error(ArgumentError)
      end
    end

    context 'non-numeric limit' do
      let(:limit) { 'a' }

      it 'raises an ArgumentError' do
        expect { subject.limit(limit) }.to raise_error(ArgumentError)
      end
    end
  end

  describe '#page' do
    it 'returns itself' do
      pending
      expect(subject.page(2)).to be subject
    end

    context 'negative page number' do
      it 'raises an ArgumentError' do
        pending
        expect { subject.page(-1) }.to raise_error(ArgumentError)
      end
    end

    context 'nil page' do
      it 'raises an ArgumentError' do
        pending
        expect { subject.page(nil) }.to raise_error(ArgumentError)
      end
    end

    context 'non-numeric page' do
      it 'raises an ArgumentError' do
        pending
        expect { subject.page('a') }.to raise_error(ArgumentError)
      end
    end
  end

  describe '#offset' do
    it 'returns itself' do
      pending
      expect(subject.offset(1)).to be subject
    end

    context 'negative offset number' do
      it 'raises an ArgumentError' do
        pending
        expect { subject.offset(-1) }.to raise_error(ArgumentError)
      end
    end

    context 'nil offset' do
      it 'raises an ArgumentError' do
        pending
        expect { subject.offset(nil) }.to raise_error(ArgumentError)
      end
    end

    context 'non-numeric offset' do
      it 'raises an ArgumentError' do
        pending
        expect { subject.offset('a') }.to raise_error(ArgumentError)
      end
    end
  end
end
