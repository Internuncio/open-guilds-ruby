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
      let!(:response) { 
        described_class.create(guild: 1, params: params)
      }

      it 'should return a batch object' do
        expect(response).to be_a OpenGuilds::Batch
      end
    end

    context 'when the batch creation fails' do
     let(:response) { 
        described_class.create(guild: 2, params: params)
      }

      it 'should raise an invalid parameters error' do
        expect{response}
          .to raise_error OpenGuilds::InvalidParametersError
      end
    end
  end

  describe '.list' do
    let!(:response) { described_class.list }

    it 'should return a list object' do
      expect(response).to be_a OpenGuilds::List
    end
  end

  describe '.get' do
    let!(:response) { described_class.get(1) }

    it 'should return a batch object' do
      expect(response).to be_a OpenGuilds::Batch
    end

    it 'should return data in the batch object' do
      expect(response.data.data.first).to be_a OpenGuilds::Datum
    end
  end
end
