require 'spec_helper'

RSpec.describe 'Authorization' do
  describe 'accessing a resource' do
    context 'when an API key is not set' do
      before do
        VCR.insert_cassette 'authorization', record: :new_episodes
        Openguilds.api_key = nil
      end

      after do
        VCR.eject_cassette
      end

      
    end
  end
end
