require 'spec_helper'

RSpec.describe OpenGuilds::Guild do
  describe '.get' do
    let!(:response) { described_class.get(ENV["GUILD_ID"]) }

    it 'should return a guild object' do
      expect(response).to be_a OpenGuilds::Guild
    end
  end
end
