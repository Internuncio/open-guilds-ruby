require 'spec_helper'

RSpec.describe Openguilds::Wallet do

  before do
    VCR.insert_cassette 'wallet', record: :new_episodes
    Openguilds.api_key = 'dca96609e8b0979b0b4f4e344e3fb36b'
  end

  after do
    VCR.eject_cassette
  end

  describe "GET #get_wallet" do
    it 'should return the wallet' do
      wallet = described_class.get_wallet()

      expect(wallet["object"]).to eq "Wallet"
    end
  end

  describe "POST #purchase_credits" do
    it "should return the wallet with new balance" do
      wallet = described_class.purchase_credits(stripe_params)

      expect(wallet["object"]).to eq "Wallet"
    end
  end

  describe "POST #pay_for_a_batch" do
    it "should return a wallet with a new balance" do

    end
  end

  def stripe_params
    {
      token: StripeMock.create_test_helper.generate_card_token,
      amount: 100,
      email: "email@example.com"
    }.to_json
  end
end