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

  # describe "POST .create" do
  #   it 'should return data from OpenGuilds' do
  #     batch = described_class.create(
  #       api_key: test1[:token],
  #       guild_id: test1[:guild_id],
  #       batch: batch_params
  #     )
  #
  #     expect(batch["status"]).to eq("Unpaid")
  #   end
  # end

  describe "GET .get_batch" do
    it 'should return a batch from OpenGuilds' do
      batch = described_class.get_batch(
        batch_id: 92,
        api_key: test1[:token]
      )
      puts batch
      expect(batch["id"]).to eq(92)
    end
  end

  # describe "DELETE .cancel_batch" do
  #   it "should cancel the batch" do
  #     batch = described_class.cancel_batch(
  #       batch_id: 9,
  #       api_key: '46cb88391c80fe60a773aaf88999ffbc'
  #     )
  #
  #     expect(batch["canceled"]).to eq true
  #   end
  # end

  # describe "POST #pay_for_a_batch" do
  #   it "should return a wallet with a new balance" do
  #     batch = described_class.pay_for_a_batch(
  #       batch_id: 83,
  #       api_key: test1[:token]
  #     )
  #
  #     expect(batch["object"]).to eq 'Wallet'
  #   end
  # end

  def batch_params
    {
      batch: {
        data_attributes: [
          parameters_attributes: [
            { key: "image_url", value: "www.images.com/image1.png" }
            ]
        ]
      }
    }
  end

  def audio_url
    "https://s3.ca-central-1.amazonaws.com/wetranscribe-development/store/0c6887143ab2f9a98a7a1c9e30afc060fdd694fb713fff6554ec7177e606"
  end

  def test1
    {
      email: "we@we.com",
      password: "111111",
      token: "1b4a66979ef58b0fecd8775a0634d8d6",
      guild_id: 7
    }
  end

  def test2
    {
      email: "test2@test.com",
      password: "111111",
      token: "a3aa489245554da43c99fd38bae746a3"
    }
  end
end
