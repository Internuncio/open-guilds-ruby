require 'spec_helper'

RSpec.describe Openguilds::Error do
  describe 'initialization' do
    it 'should take an error and a status' do
      expect(Openguilds::Error.new(error: 'Not Found', status: 404))
        .to be_a Openguilds::Error
    end
  end
end
