require 'spec_helper'

RSpec.describe Openguilds::Client do

  before do
    VCR.insert_cassette 'client', record: :new_episodes
  end

  after do
    VCR.eject_cassette
  end

  describe "#initialization" do
    it "must include HTTParty" do
      expect(described_class.ancestors).to include(HTTParty)
    end
  end

  describe "#authorize!" do
    it "must return a Client" do
      expect(described_class.authorize!("a4b25f60db4c7c9999ad42ccc5d767d2").class.name).
        to eq("Openguilds::Client")
    end
  end
end
