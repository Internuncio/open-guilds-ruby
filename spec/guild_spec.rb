require 'spec_helper'

RSpec.describe Openguilds::Guild do

  before do
    VCR.insert_cassette 'guild', record: :new_episodes
  end

  after do
    VCR.eject_cassette
  end

  describe '#initialization' do
    it 'must include HTTParty' do
      expect(described_class.ancestors).to include(HTTParty)
    end
  end

  describe "GET .get_guild" do
    it 'should return a guild from OpenGuilds' do
      guild = described_class.get_guild(
        guild_id: 47,
        api_key: test_account[:token]
      )

      expect(guild["id"]).to eq(47)
    end
  end

  def test_account
    {
      email: "we@we.com",
      password: "111111",
      token: "1b4a66979ef58b0fecd8775a0634d8d6",
      guild_id: 47
    }
  end
end
