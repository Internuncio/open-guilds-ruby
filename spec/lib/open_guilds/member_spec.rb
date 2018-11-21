require 'spec_helper'

RSpec.describe OpenGuilds::Member do
  around &method(:with_fake_server)

  describe '.get' do
    let!(:response) { described_class.get(1) }

    it 'should return a guild object' do
      expect(response).to be_a OpenGuilds::Member
    end
  end

  describe '.find' do
    let!(:response) { 
      described_class.find(
        guild: 1,
        email: 'email@example.com'
      )
    }

    it 'should return a guild object' do
      expect(response).to be_a OpenGuilds::Member
    end
  end

  describe '.list' do
    let!(:response) { described_class.list(1) }

    it 'should return a list object' do
      expect(response).to be_a OpenGuilds::List
    end
  end
end
