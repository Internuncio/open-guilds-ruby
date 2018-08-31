require 'spec_helper'

RSpec.describe Openguilds::Authentication do
  describe 'accessing the authentication token' do
    context 'when email & password are valid' do
      before do
        VCR.insert_cassette 'authentication', record: :new_episodes
      end
      it 'should reuturn authentication token' do
        token = described_class.basic_auth(
          email: "s@s.com",
          password: "111111"
        )

        expect(token[:username]).not_to be_nil
      end
    end

    context 'when email or password are not valid' do
      before do
        VCR.insert_cassette 'authentication error', record: :new_episodes
      end
      it 'should raise Argument Error' do
        expect{described_class.basic_auth({})}.to raise_error ArgumentError
      end
    end
  end
end
