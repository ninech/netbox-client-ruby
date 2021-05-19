require 'spec_helper'

module NetboxClientRuby
  module Extras
    describe Tag, faraday_stub: true do
      let(:entity_id) { 1 }
      let(:base_url) { '/api/extras/tags/' }
      let(:request_url) { "#{base_url}#{entity_id}.json" }
      let(:response) { File.read("spec/fixtures/extras/tag_#{entity_id}.json") }

      subject { Tag.new entity_id }

      describe '#id' do
        it 'shall be the expected id' do
          expect(subject.id).to eq(entity_id)
        end
      end

      describe '#name' do
        it 'should fetch the data' do
          expect(faraday).to receive(:get).and_call_original

          subject.name
        end

        it 'shall be the expected name' do
          expect(subject.name).to eq('Production')
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
          expect(subject.update(name: 'noob').name).to eq('Production')
        end
      end

      describe '.reload' do
        it 'should reload the object' do
          expect(faraday).to receive(request_method).twice.and_call_original

          subject.reload
          subject.reload
        end
      end

      describe '.save' do
        let(:name) { 'foobar' }
        let(:slug) { name }
        let(:request_params) { { 'name' => name, 'slug' => slug } }

        context 'update' do
          let(:request_method) { :patch }

          subject do
            entity = Tag.new entity_id
            entity.name = name
            entity.slug = slug
            entity
          end

          it 'does not call PATCH until save is called' do
            expect(faraday).to_not receive(request_method)
            expect(faraday).to_not receive(:get)

            expect(subject.name).to eq(name)
            expect(subject.slug).to eq(slug)
          end

          it 'calls PATCH when save is called' do
            expect(faraday).to receive(request_method).and_call_original

            expect(subject.save).to be(subject)
          end

          it 'Reads the answer from the PATCH answer' do
            expect(faraday).to receive(request_method).and_call_original

            subject.save
            expect(subject.name).to eq('Production')
            expect(subject.slug).to eq('production')
          end
        end

        context 'create' do
          let(:request_method) { :post }
          let(:request_url) { base_url }

          subject do
            entity = Tag.new
            entity.name = name
            entity.slug = slug
            entity
          end

          it 'does not POST until save is called' do
            expect(faraday).to_not receive(request_method)
            expect(faraday).to_not receive(:get)

            expect(subject.name).to eq(name)
            expect(subject.slug).to eq(slug)
          end

          it 'POSTs the data upon a call of save' do
            expect(faraday).to receive(request_method).and_call_original

            expect(subject.save).to be(subject)
          end

          it 'Reads the answer from the POST' do
            expect(faraday).to receive(request_method).and_call_original

            subject.save

            expect(subject.id).to be(1)
            expect(subject.name).to eq('Production')
            expect(subject.slug).to eq('production')
          end
        end
      end
    end
  end
end
