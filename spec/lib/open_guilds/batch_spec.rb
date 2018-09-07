require 'spec_helper'

RSpec.describe OpenGuilds::Batch do
  describe '.create' do
    let(:params) {
      {
        batch: {
          data_attributes: [
            { 
              parameters_attributes: [ 
                { key: 'key', value: 'value' } 
              ]
            }
          ]
        }
      }
    }


    context 'when the batch creation is successful', 
      vcr: { cassette_name: 'create_batch/successful' } do
      let!(:response) { described_class.create(ENV["GUILD_ID"], params) }

      it 'should return a batch object' do
        expect(response).to be_a OpenGuilds::Batch
      end
    end

    context 'when the batch creation fails',
     vcr: { cassette_name: 'create_batch/bad_params' } do
      let(:response) { described_class.create(ENV["GUILD_ID"], {}) }

      it 'should return a batch object' do
        expect{response}.to raise_error OpenGuilds::InvalidParametersError
      end
    end
  end

  describe '.show', vcr: { cassette_name: 'show_batch/successful' } do
    let!(:response) { described_class.get(ENV["BATCH_ID"]) }

    it 'should return a 200 response' do
      expect(response).to be_a OpenGuilds::Batch
    end
  end
end
