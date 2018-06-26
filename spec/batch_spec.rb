require 'spec_helper'

RSpec.describe Openguilds::Batch do

  before do
    VCR.insert_cassette 'batch', record: :new_episodes
    Openguilds.api_key = 'a4b25f60db4c7c9999ad42ccc5d767d2'
  end

  after do
    VCR.eject_cassette
  end

  describe '#initialization' do
    it 'must include HTTParty' do
      expect(described_class.ancestors).to include(HTTParty)
    end
  end

  describe "POST .create" do
    it 'should return data from OpenGuilds' do
      batch = described_class.create(
        type: "audio",
        guild: 2,
        audio_url: audio_url
      )
      expect(batch).not_to be_nil
    end
  end

  def audio_url
    "https://s3.ca-central-1.amazonaws.com/wetranscribe-development/store/0c6887143ab2f9a98a7a1c9e30afc060fdd694fb713fff6554ec7177e606"
  end
end
