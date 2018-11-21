require 'spec_helper'

RSpec.describe OpenGuilds::Guild do
  around &method(:with_fake_server)

  describe '.get' do
    let!(:response) { described_class.get(1) }

    it 'should return a guild object' do
      expect(response).to be_a OpenGuilds::Guild
    end
  end

  describe '.list' do
    let!(:response) { described_class.list }

    it 'should return a list object' do
      expect(response).to be_a OpenGuilds::List
    end
  end
end
