require 'spec_helper'

RSpec.describe OpenGuilds::Batch do
  around &method(:with_fake_server)

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


    context 'when the batch creation is successful' do
      let!(:response) { described_class.create(guild: 1, params: params) }

      it 'should return a batch object' do
        expect(response).to be_a OpenGuilds::Batch
      end
    end

    context 'when the batch creation fails' do
      let(:response) { described_class.create(guild: 2, params: params) }

      it 'should raise an invalid parameters error' do
        expect{response}.to raise_error OpenGuilds::InvalidParametersError
      end
    end
  end

  describe '.show' do
    let!(:response) { described_class.get(1) }

    it 'should return a batch object' do
      expect(response).to be_a OpenGuilds::Batch
    end

    it 'should return data in the batch object' do
      expect(response.data.length).to eq 1
      expect(response.data.first).to be_a OpenGuilds::Datum
    end
  end

  describe '.pay' do
    let!(:response) { described_class.pay(1) }

    it 'should return the transaction object' do
      expect(response).to be_a OpenGuilds::Transaction
    end
  end

  describe '.cancel' do
    let!(:response) { described_class.cancel(ENV["REFUNDED_BATCH_ID"]) }

    it 'should return the batch object' do
      expect(response).to be_a OpenGuilds::Batch
    end

    it 'should return the correct status' do
      expect(response.canceled?).to eq true
    end
  end
end
