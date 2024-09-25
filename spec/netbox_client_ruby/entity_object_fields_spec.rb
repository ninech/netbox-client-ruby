# frozen_string_literal: true

require 'spec_helper'

RSpec.describe NetboxClientRuby::Entity do
  class TestSubPoro
    attr_accessor :name

    def initialize(data)
      @name = data['name']
    end
  end
  class TestSubEntity
    include NetboxClientRuby::Entity

    id my_id: 'name'
    path 'tests/:my_id/sub'

    def initialize(my_id, data = nil)
      self.data = data
      super my_id: my_id
    end
  end
  module ArrayObjectField
    class TestEntitySimple
      include NetboxClientRuby::Entity

      id test_id: 'id'
      path 'tests/:test_id'
      object_fields 'an_object_array'

      def initialize
        super test_id: 42
      end
    end
    class TestEntityPoro
      include NetboxClientRuby::Entity

      id test_id: 'id'
      path 'tests/:test_id'
      object_fields an_object_array: TestSubPoro

      def initialize
        super test_id: 42
      end
    end
    class TestEntityProc
      include NetboxClientRuby::Entity

      id test_id: 'id'
      path 'tests/:test_id'
      object_fields an_object_array: proc { |data| TestSubEntity.new(@test_id, data) }

      def initialize
        super test_id: 42
      end
    end
  end
  module ObjectField
    class TestEntityPlain
      include NetboxClientRuby::Entity

      id test_id: 'id'
      path 'tests/:test_id'
      object_fields :an_object

      def initialize
        super test_id: 42
      end
    end
    class TestEntityPoro
      include NetboxClientRuby::Entity

      id test_id: 'id'
      path 'tests/:test_id'
      object_fields an_object: TestSubPoro

      def initialize
        super test_id: 42
      end
    end
    class TestEntityProc
      include NetboxClientRuby::Entity

      id test_id: 'id'
      path 'tests/:test_id'
      object_fields an_object: proc { |data| TestSubEntity.new(@test_id, data) }

      def initialize
        super test_id: 42
      end
    end
  end

  let(:faraday_stubs) { Faraday::Adapter::Test::Stubs.new }
  let(:faraday) do
    Faraday.new(url: 'https://netbox.test/api/', headers: NetboxClientRuby::Connection.headers) do |faraday|
      faraday.response :json, content_type: /\bjson$/
      faraday.adapter :test, faraday_stubs
    end
  end
  let(:response_json) do
    <<-json
      {
        "id": 42,
        "name": "Beat",
        "boolean": true,
        "number": 1,
        "float_number": 1.2,
        "date": "2014-05-28T18:46:18.764425Z",
        "an_object": {
          "key": "value",
          "second": 2
        },
        "an_array": [],
        "an_object_array": [
          {
            "name": "obj1"
          }, {
            "name": "obj2"
          }, {
            "name": "obj3"
          }
        ],
        "an_object": {
          "name": "obj1"
        },
        "counter": 1
      }
    json
  end
  let(:url) { '/api/tests/42' }

  before do
    faraday_stubs.get(url) do |_env|
      [200, { content_type: 'application/json' }, response_json]
    end
    allow(Faraday).to receive(:new).and_return faraday
  end

  describe 'objectification of the content of array fields' do
    context 'anonymous classes' do
      let(:subject) { ArrayObjectField::TestEntitySimple.new }

      it 'does not return `an_object_array` as Hashes' do
        expect(subject.an_object_array).to be_a Array
        subject.an_object_array.each do |obj|
          expect(obj).to_not be_a Hash
        end
      end

      it 'returns the correct values' do
        arr = subject.an_object_array

        expect(arr[0].name).to eq 'obj1'
        expect(arr[1].name).to eq 'obj2'
        expect(arr[2].name).to eq 'obj3'
      end

      it 'does not call the server for the sub-object' do
        expect(faraday).to receive(:get).once.and_call_original

        expect(subject[:name]).to eq 'Beat'
        expect(subject.an_object_array).to_not be_a Hash
      end

      it 'is a new object everytime' do
        a = subject.an_object_array
        b = subject.an_object_array

        expect(a).to_not be b
        expect(b).to_not be a
      end
    end

    context 'poro classes' do
      let(:subject) { ArrayObjectField::TestEntityPoro.new }

      it 'does not return `an_object_array` as Hashes' do
        expect(subject.an_object_array).to be_a Array
        subject.an_object_array.each do |obj|
          expect(obj).to be_a TestSubPoro
        end
      end

      it 'returns the correct values' do
        arr = subject.an_object_array

        expect(arr[0].name).to eq 'obj1'
        expect(arr[1].name).to eq 'obj2'
        expect(arr[2].name).to eq 'obj3'
      end

      it 'does not call the server for the sub-object' do
        expect(faraday).to receive(:get).once.and_call_original

        expect(subject[:name]).to eq 'Beat'
        expect(subject.an_object_array).to_not be_a Hash
      end

      it 'is a new object everytime' do
        a = subject.an_object_array
        b = subject.an_object_array

        expect(a).to_not be b
        expect(b).to_not be a
      end
    end

    context 'entity classes' do
      let(:subject) { ArrayObjectField::TestEntityProc.new }

      it 'does not return `an_object_array` as Hashes' do
        expect(subject.an_object_array).to be_a Array
        subject.an_object_array.each do |obj|
          expect(obj).to be_a TestSubEntity
        end
      end

      it 'returns the correct values' do
        arr = subject.an_object_array

        expect(arr[0].name).to eq 'obj1'
        expect(arr[1].name).to eq 'obj2'
        expect(arr[2].name).to eq 'obj3'
      end

      it 'does not call the server for the sub-object' do
        expect(faraday).to receive(:get).once.and_call_original

        expect(subject[:name]).to eq 'Beat'
        expect(subject.an_object_array).to_not be_a Hash
      end

      it 'is a new object everytime' do
        a = subject.an_object_array
        b = subject.an_object_array

        expect(a).to_not be b
        expect(b).to_not be a
      end
    end
  end

  describe 'objectification of the content of object fields' do
    context 'anonymous class' do
      let(:subject) { ObjectField::TestEntityPlain.new }

      it 'does not return `an_object` as a Hash' do
        expect(subject.an_object).to_not be_a Hash
      end

      it 'returns the correct values' do
        expect(subject.an_object.name).to eq 'obj1'
      end

      it 'does not call the server for the sub-object' do
        expect(faraday).to receive(:get).once.and_call_original

        expect(subject[:name]).to eq 'Beat'
        expect(subject.an_object).to_not be_a Hash
      end

      it 'is a new object everytime' do
        a = subject.an_object
        b = subject.an_object

        expect(a).to_not be b
        expect(b).to_not be a
      end
    end

    context 'poro class' do
      let(:subject) { ObjectField::TestEntityPoro.new }

      it 'does not return `an_object` as a Hash' do
        expect(subject.an_object).to be_a TestSubPoro
      end

      it 'returns the correct values' do
        expect(subject.an_object.name).to eq 'obj1'
      end

      it 'does not call the server for the sub-object' do
        expect(faraday).to receive(:get).once.and_call_original

        expect(subject[:name]).to eq 'Beat'
        expect(subject.an_object).to_not be_a Hash
      end

      it 'is a new object everytime' do
        a = subject.an_object
        b = subject.an_object

        expect(a).to_not be b
        expect(b).to_not be a
      end
    end

    context 'entity class' do
      let(:subject) { ObjectField::TestEntityProc.new }

      it 'does not return `an_object` as a Hashe' do
        expect(subject.an_object).to_not be_a Hash
      end

      it 'returns the correct values' do
        expect(subject.an_object.name).to eq 'obj1'
      end

      it 'does not call the server for the sub-object' do
        expect(faraday).to receive(:get).once.and_call_original

        expect(subject[:name]).to eq 'Beat'
        expect(subject.an_object).to_not be_a Hash
      end

      it 'is a new object everytime' do
        a = subject.an_object
        b = subject.an_object

        expect(a).to_not be b
        expect(b).to_not be a
      end
    end
  end
end
