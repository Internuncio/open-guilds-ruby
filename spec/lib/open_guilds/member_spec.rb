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

  describe '.invite' do
    let!(:response) {
      described_class.invite(
        guild: 1,
        email: 'email@example.com'
      )
    }

    it 'should return an invite object' do
      expect(response).to be_a OpenGuilds::Invite
    end
  end

  describe '.remove' do
    let!(:response) { described_class.remove(1) }

    it 'should return an invite object' do
      expect(response).to be_a OpenGuilds::Member
    end

    it 'should set the object to deleted' do
      expect(response.deleted?).to eq true
    end
  end
end
