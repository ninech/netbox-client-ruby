# frozen_string_literal: true

require 'spec_helper'
require 'digest/md5'

RSpec.describe NetboxClientRuby::Secrets::RSAKeyPair, faraday_stub: true do
  let(:request_url) { '/api/secrets/generate-rsa-key-pair/' }
  let(:response) { File.read('spec/fixtures/secrets/generate-rsa-key-pair.json') }

  # MD5, to keep the strings in this spec at a reasonable length
  let(:expected_public_key_md5) { '29bdf13ae078d73fab4848634b2c3c37' }
  let(:expected_private_key_md5) { '91e45a978633a43de04c3310bd550645' }

  describe '#public_key' do
    it 'queries the api' do
      expect(faraday).to receive(request_method).once.and_call_original

      expect(md5sum(subject.public_key)).to eql(expected_public_key_md5)
    end

    context 'then #private_key' do
      it 'queries the api just once' do
        expect(faraday).to receive(request_method).once.and_call_original

        expect(md5sum(subject.public_key)).to eql(expected_public_key_md5)
        expect(md5sum(subject.private_key)).to eql(expected_private_key_md5)
      end
    end
  end

  describe '#private_key' do
    it 'queries the api' do
      expect(faraday).to receive(request_method).once.and_call_original

      expect(md5sum(subject.private_key)).to eql(expected_private_key_md5)
    end

    context 'then #public_key' do
      it 'queries the api just once' do
        expect(faraday).to receive(request_method).once.and_call_original

        expect(md5sum(subject.private_key)).to eql(expected_private_key_md5)
        expect(md5sum(subject.public_key)).to eql(expected_public_key_md5)
      end
    end
  end

  describe '#reload' do
    it 'sends a new query' do
      expect(faraday).to receive(request_method).twice.and_call_original

      expect(md5sum(subject.public_key)).to eql(expected_public_key_md5)
      expect(md5sum(subject.private_key)).to eql(expected_private_key_md5)

      subject.reload

      expect(md5sum(subject.public_key)).to eql(expected_public_key_md5)
      expect(md5sum(subject.private_key)).to eql(expected_private_key_md5)
    end

    it 'does not cause any effect' do
      expect(subject.reload).to be_nil
    end
  end

  def md5sum(value)
    Digest::MD5.hexdigest value
  end
end
