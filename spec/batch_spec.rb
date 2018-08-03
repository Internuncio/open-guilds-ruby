require 'spec_helper'

RSpec.describe Openguilds::Batch do

  before do
    VCR.insert_cassette 'batch', record: :new_episodes
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
        api_key: 'dca96609e8b0979b0b4f4e344e3fb36b',
        audio_url: audio_url,
        guild_id: 4
      )

      expect(batch["status"]).to eq("Unpaid")
    end
  end

  describe "GET .get_batch" do
    it 'should return a batch from OpenGuilds' do
      batch = described_class.get_batch(
        batch_id: 3,
        api_key: 'dca96609e8b0979b0b4f4e344e3fb36b'
      )

      expect(batch["status"]).to eq("Paid")
    end
  end
  #
  # describe "DELETE .cancel_batch" do
  #   it "should cancel the batch" do
  #     batch = described_class.cancel_batch(3)
  #
  #     expect(batch["canceled"]).to eq true
  #   end
  # end
  #
  describe "POST #pay_for_a_batch" do
    it "should return a wallet with a new balance" do
      batch = described_class.pay_for_a_batch(
        batch_id: 5,
        api_key: 'dca96609e8b0979b0b4f4e344e3fb36b'
      )

      expect(batch["object"]).to eq 'Wallet'
    end
  end

  def audio_url
    "https://s3.ca-central-1.amazonaws.com/wetranscribe-development/store/0c6887143ab2f9a98a7a1c9e30afc060fdd694fb713fff6554ec7177e606"
  end
end
