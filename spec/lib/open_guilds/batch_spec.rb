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

    it 'should return a batch object' do
      expect(response).to be_a OpenGuilds::Batch
    end

    it 'should return data in the batch object' do
      expect(response.data.length).to eq 1
      expect(response.data.first).to be_a OpenGuilds::Datum
    end
  end

  describe '.fund', vcr: { cassette_name: 'fund_batch/successful' } do
    let!(:response) { described_class.fund(ENV["BATCH_ID"]) }

    it 'should return the wallet object' do
      expect(response).to be_a OpenGuilds::List
    end

    it 'should return the latest transaction first' do
      expect(response.data.first).to be_a OpenGuilds::Transaction
    end
  end

  describe '.cancel', vcr: { cassette_name: 'cancel_batch/successful' } do
    let!(:response) { described_class.cancel(ENV["REFUNDED_BATCH_ID"]) }

    it 'should return the wallet object' do
      expect(response).to be_a OpenGuilds::List
    end

    it 'should return the transactions' do
      expect(response.data.first).to be_a OpenGuilds::Transaction
    end
  end
end
