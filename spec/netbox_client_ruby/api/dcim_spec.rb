require 'spec_helper'

describe NetboxClientRuby::DCIM do
  {
    sites: NetboxClientRuby::Sites,
    regions: NetboxClientRuby::Regions,
    manufacturers: NetboxClientRuby::Manufacturers
  }.each do |method, expected_class|
    describe ".#{method}" do
      subject { NetboxClientRuby::DCIM.new.public_send(method) }

      context 'is of the correct type' do
        it { is_expected.to be_a expected_class }
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

  {
    site: NetboxClientRuby::Site,
    region: NetboxClientRuby::Region,
    manufacturer: NetboxClientRuby::Manufacturer
  }.each do |method, expected_class|
    describe ".#{method}" do
      let(:id) { 1 }
      subject { NetboxClientRuby::DCIM.new.public_send(method, id) }

      context 'is of the expected type' do
        it { is_expected.to be_a expected_class }
      end

      context 'it is a new instance each time' do
        it do
          is_expected
            .to_not be NetboxClientRuby::DCIM.new.public_send(method, id)
        end
      end

      context 'is an Entity object' do
        it { is_expected.to respond_to(:get!) }
      end
    end
  end
end
