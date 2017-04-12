require "spec_helper"

RSpec.describe Netbox::Client::Ruby do
  it "has a version number" do
    expect(Netbox::Client::Ruby::VERSION).not_to be nil
  end

  it "does something useful" do
    expect(false).to eq(true)
  end
end
