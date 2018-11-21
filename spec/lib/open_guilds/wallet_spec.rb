require 'spec_helper'

RSpec.describe OpenGuilds::Wallet do
  around &method(:with_fake_server)

  describe '.list' do
    let!(:response) { described_class.list }

    it 'should return a list object' do
      expect(response).to be_a OpenGuilds::List
    end
  end

  describe '.get' do
    let!(:response) { described_class.get(1) }

    it 'should return a wallet object' do
      expect(response).to be_a OpenGuilds::Wallet
    end
  end
end
