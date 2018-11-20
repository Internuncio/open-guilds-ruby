require 'spec_helper'

RSpec.describe OpenGuilds::Wallet do
  describe '.get' do
    let!(:response) { described_class.get() }

    it 'should return a wallet object' do
      expect(response).to be_a OpenGuilds::Wallet
    end

    it 'should return the transaction object' do
      expect(response.transactions.length).to eq 1
      expect(response.transactions.first).to be_a OpenGuilds::Transaction
    end
  end
end
