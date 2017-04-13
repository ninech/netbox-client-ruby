require 'spec_helper'

describe NetboxClientRuby::DCIM do
  {
    sites: NetboxClientRuby::Sites
  }.each do |method, klass|
    describe ".#{method}" do
      subject { NetboxClientRuby::DCIM.new.public_send(method) }

      context 'is of the correct type' do
        it { is_expected.to be_a klass }
      end

      context 'is a different instance each time' do
        it do
          is_expected
            .to_not be NetboxClientRuby::DCIM.new.public_send(method)
        end
      end

      context 'is an Entities object' do
        it { is_expected.to respond_to(:get!) }
      end
    end
  end
end
