require 'spec_helper'

RSpec.describe OpenGuilds::Batch do
  describe '.create', vcr: { cassette_name: 'create_batch/successful' } do
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

    let(:response) { described_class.create(1, params) }
    before do
      response
    end

    it 'should return a 201 response' do
      expect(response.http_status).to eq 201
    end
  end
end
