require 'spec_helper'

RSpec.describe Openguilds::Registration do
  describe 'register a new account' do
    context 'when the email & passwords are valid' do
      before do
        VCR.insert_cassette 'registration', record: :new_episodes
      end

      it 'should return success message' do
        response = described_class
          .register(email: "test@test.com",
                    password: "111111",
                    password_confirmation: "111111")

        expect(response['message']).to match(/User created successfully/)
      end
    end
  end
end
