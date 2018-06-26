require 'spec_helper'

RSpec.describe Openguilds::Openguild do

  before do

  end
  
  describe 'initialization' do
    it 'must contain HTTParty' do
      expect(described_class.ancestors).to include(HTTParty)
    end
  end
end
