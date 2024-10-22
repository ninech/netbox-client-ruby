# frozen_string_literal: true

require 'spec_helper'

RSpec.describe NetboxClientRuby::Entity, faraday_stub: true do
  class TestEntity
    include NetboxClientRuby::Entity

    attr_accessor :name

    id test_id: 'id'
    readonly_fields :counter
    deletable true
    path 'tests/:test_id'
    creation_path 'tests/'
    object_fields :an_object, :an_object_array

    def initialize(id = nil, name = nil)
      @name = name
      super id
    end
  end
  class TestEntity2
    include NetboxClientRuby::Entity

    id test_id: 'id'
    readonly_fields :counter
    creation_path 'tests/'
    # not deletable

    path 'tests/42'
  end
  class TestEntity3
    include NetboxClientRuby::Entity

    id test_id: 'id'
    # Wrong URL (starts with '/')
    path '/tests/42'
  end
  class TestEntity4
    include NetboxClientRuby::Entity

    id test_id: 'id'
    # no path defined
  end

  let(:raw_data) do
    {
      'id' => 43,
      'name' => 'Beat',
      'boolean' => true,
      'number' => 1,
      'float_number' => 1.2,
      'date' => '2014-05-28T18:46:18.764425Z',
      'an_object' => {
        'key' => 'value',
        'second' => 2
      },
      'an_array' => [],
      'an_object_array' => [
        { 'name' => 'obj1' },
        { 'name' => 'obj2' },
        { 'name' => 'obj3' }
      ],
      'counter' => 1
    }
  end

  let(:response) { JSON.generate(raw_data) }
  let(:request_url) { '/api/tests/42' }
  let(:subject) { TestEntity.new 42, 'Urs' }

  it 'gets the name from the TestEntity' do
    expect(subject.name).to eq 'Urs'
  end

  describe 'fetch values' do
    it 'returns the correct name' do
      expect(subject[:name]).to eq 'Beat'
    end

    it 'caches the data' do
      expect(faraday).to receive(:get).once.and_call_original

      expect(subject[:name]).to eq 'Beat'
      expect(subject[:name]).to eq 'Beat'
    end

    it 'fetches the data when asked to' do
      expect(faraday).to receive(:get).twice.and_call_original
      subject.reload
      subject.reload
    end

    it 'returns itself when reloading' do
      expect(subject.reload).to be subject
    end

    it 'raises a NoMethodError when the field is not in the response' do
      expect { subject.nope }.to raise_error NoMethodError
    end

    it 'returns a number' do
      expect(subject.number).to be 1
    end

    it 'returns a floating-point number' do
      expect(subject.float_number).to be 1.2
    end

    it 'returns an Array' do
      expect(subject.an_array).to be_a Array
      expect(subject.an_array.length).to be 0
    end

    it 'returns the raw data' do
      expect(subject.raw_data!).to eq raw_data
    end

    describe '#url' do
      it 'returns the url of the resource' do
        expect(subject.url).to eq 'http://netbox.test/api/tests/42'
      end
    end
  end

  describe 'send values' do
    context 'updating the object' do
      let(:request_method) { :patch }
      let(:request_params) { { 'name' => 'Fritz' } }

      it 'raises a NoMethodError when the field is not modifiable' do
        expect { subject.counter = 1 }.to raise_error NoMethodError
      end

      it 'returns the value that has been set' do
        subject.name = 'Fritz'
        subject[:name] = 'Alfred'
        expect(subject.name).to eq 'Fritz'
        expect(subject[:name]).to eq 'Alfred'
      end

      it 'sends PATCH to the server' do
        expect(faraday).to receive(:patch).and_call_original

        subject[:name] = 'Fritz'
        expect(subject.save).to be subject
        expect(subject.name).to eq 'Urs'

        # this value is read from the response, which is 'Beat', and not 'Fritz'
        # this also checks implicitly that the @dirty cache has been emptied
        expect(subject[:name]).to eq 'Beat'
      end

      it 'does not send PATCH to the server when nothing changed' do
        expect(faraday).to_not receive(:patch)

        expect(subject.save).to be subject
      end

      it 'does not send PATCH to the server when nothing valid changed' do
        expect(faraday).to_not receive(:patch)

        expect(subject.update(counter: 'It Is')).to be subject
      end
    end

    context 'creating the object' do
      let(:subject) { TestEntity.new }
      let(:name) { 'foobar' }

      let(:request_url) { '/api/tests/' }
      let(:request_method) { :post }
      let(:request_params) { { 'name' => name } }

      it 'does raise an exception when trying to fetch data' do
        expect { subject.reload }.to raise_error(NetboxClientRuby::LocalError)
      end

      it 'returns itself when calling save' do
        subject[:name] = name

        expect(subject.save).to be(subject)
      end

      it 'calls post' do
        expect(faraday).to receive(:post).and_call_original

        subject[:name] = name

        subject.save
      end

      it 'parses the response' do
        expect(faraday).to_not receive(:get)

        subject[:name] = name

        subject.save

        expect(subject.test_id).to be(43)
        expect(subject.boolean).to be(true)
      end

      context 'save with more data' do
        let(:hash) { { 'one' => 1, 'two' => 2 } }
        let(:array) { [1, 2, 3] }
        let(:number) { 3 }
        let(:request_params) { { 'name' => name, 'number' => number, 'hash' => hash, 'array' => array } }

        it 'sends all the data' do
          expect(faraday).to receive(:post).and_call_original

          subject[:name] = name
          subject.number = number
          subject.hash = hash
          subject.array = array

          subject.save
        end
      end

      context 'setting an object field' do
        let(:test_object) { Object.new }
        let(:request_params) { { 'an_object' => test_object } }

        it 'does not call the remote yet' do
          expect(faraday).to_not receive(:post)

          subject.an_object = test_object

          expect(subject.an_object).to be(test_object)
        end

        it 'sends the object to faraday for serialization' do
          expect(faraday).to receive(:post).and_call_original

          subject.an_object = test_object

          expect(subject.save).to be(subject)
        end
      end

      context 'by supplying values through the constructor' do
        let(:subject) { TestEntity2.new name: name }

        it 'does a proper POST upon save' do
          expect(faraday).to receive(:post).and_call_original

          subject.save
        end
      end
    end
  end

  describe 'id handling' do
    it 'assigns the id' do
      expect(subject.test_id).to be(42)
    end

    it 'does not respond to value changes on ids' do
      expect { subject.test_id = 667 }.to raise_error NoMethodError
    end

    it 'does not call out for getting ids' do
      expect(faraday).to_not receive(:get)

      subject.test_id
    end
  end

  describe 'api class has readonly_fields' do
    let(:subject) { TestEntity2.new 42 }

    it 'still runs a fetch' do
      expect(faraday).to receive(:get).once.and_call_original

      expect(subject.counter).to eq 1
    end

    it 'does not send PATCH' do
      expect(faraday).to_not receive(:patch)

      expect(subject.update(counter: 2)).to be subject
    end

    it 'does not allow setting any value' do
      expect { subject.counter = 'Mars' }.to raise_error NoMethodError
    end
  end

  describe '#delete' do
    let(:request_method) { :delete }

    context 'with response' do
      let(:response) { '{"id":42}' }
      let(:status) { 200 }

      it 'deletes the entity from the server' do
        expect(faraday).to receive(:delete).and_call_original

        expect(subject.delete).to be subject
      end

      it 'calls the server only once' do
        expect(faraday).to receive(:delete).once.and_call_original

        expect(subject.delete).to be subject
        expect(subject.delete).to be subject
      end

      it 'parses the response' do
        expect(subject.delete).to be subject
        expect(subject[:name]).to be_nil
      end

      context 'non-deletable entity' do
        let(:subject) { TestEntity2.new 42 }
        it 'raises an error' do
          expect { subject.delete }.to raise_error NetboxClientRuby::LocalError
        end
      end
    end

    context 'with empty response' do
      let(:response) { '' }
      let(:status) { 204 }

      it 'deletes the entity from the server' do
        expect(faraday).to receive(:delete).and_call_original

        expect(subject.delete).to be subject
      end

      it 'calls the server only once' do
        expect(faraday).to receive(:delete).once.and_call_original

        expect(subject.delete).to be subject
        expect(subject.delete).to be subject
      end

      it 'parses the response' do
        expect(faraday).to_not receive(:get)

        expect(subject.delete).to be subject
        expect { subject[:name] }.to raise_error NoMethodError
      end

      context 'non-deletable entity' do
        let(:subject) { TestEntity2.new 42 }
        it 'raises an error' do
          expect { subject.delete }.to raise_error NetboxClientRuby::LocalError
        end
      end
    end
  end

  describe 'a wrong path is given' do
    let(:subject) { TestEntity3.new 42 }

    it 'raises an exception' do
      expect { subject.name }.to raise_error Faraday::Adapter::Test::Stubs::NotFound
    end
  end

  describe 'no path given' do
    let(:subject) { TestEntity4.new 42 }

    it 'raises an exception' do
      expect { subject.reload }.to raise_error ArgumentError
    end
  end

  describe 'objectification of fields' do
    it 'does not return `an_object` as Hash' do
      expect(subject.an_object).to_not be_a Hash
    end

    it 'returns the correct values' do
      expect(subject.an_object).to_not be_a Hash
      expect(subject.an_object.key).to eq 'value'
      expect(subject.an_object.second).to be 2
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

  describe 'calling an attribute' do
    describe 'for an unsaved entity' do
      it 'should raise a NoMethodError' do
        expect { subject.unknown_attribute }.to raise_error NoMethodError
      end
    end
  end
end
