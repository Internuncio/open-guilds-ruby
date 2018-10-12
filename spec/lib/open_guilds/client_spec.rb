require 'spec_helper'

RSpec.describe OpenGuilds::Client do
  describe ".should_retry?" do
    let(:result) { described_class.should_retry?(error, num_retries) }

    before do
      allow(OpenGuilds).to(
        receive(:max_network_retries)
        .and_return(2)
      )
    end

    context 'when given a timeout error' do
      let(:error) { Faraday::TimeoutError.new("") }
      let(:num_retries) { 0 }

      it 'returns true' do
        expect(result).to eq true
      end
    end

    context 'when given a connection failed error' do
      let(:error) { Faraday::ConnectionFailed.new("") }
      let(:num_retries) { 0 }

      it 'returns true' do
        expect(result).to eq true
      end
    end

    context 'when returning a 409 conflict http status' do
      let(:error) {
        Faraday::ClientError.new(
          OpenGuilds::TestData.make_rate_limit_error[:error][:message],
          status: 409
        )
      }
      let(:num_retries) { 0 }

      it 'returns true' do
        expect(result).to eq true
      end
    end

    context 'when at its maximum count' do
      let(:error) { RuntimeError.new }
      let(:num_retries) { OpenGuilds.max_network_retries }

      it 'returns false' do
        expect(result).to eq false
      end
    end
  end

  describe ".sleep_time" do
    it 'should grow exponentially' do
      allow(described_class).to receive(:rand).and_return(1)
      allow(OpenGuilds).to receive(:initial_network_retry_delay).and_return(1)
      allow(OpenGuilds).to receive(:max_network_retry_delay).and_return(999)

      network_retry_delay = OpenGuilds.initial_network_retry_delay

      expect(described_class.sleep_time(1)).to eq network_retry_delay
      expect(described_class.sleep_time(2)).to eq network_retry_delay * 2
      expect(described_class.sleep_time(3)).to eq network_retry_delay * 4
      expect(described_class.sleep_time(4)).to eq network_retry_delay * 8
    end

    it 'should enforce the max_network_retry_delay' do
      allow(described_class).to receive(:rand).and_return(1)
      allow(OpenGuilds).to receive(:initial_network_retry_delay).and_return(1)
      allow(OpenGuilds).to receive(:max_network_retry_delay).and_return(2)

      expect(described_class.sleep_time(1)).to eq 1
      expect(described_class.sleep_time(2)).to eq 2
      expect(described_class.sleep_time(3)).to eq 2
      expect(described_class.sleep_time(4)).to eq 2
    end
  end

  describe "#initialize" do
    it "should set OpenGuilds.default_conn" do
      expect(described_class.new.connection).to_not eq nil
    end

    it "should set a different connection if one was specified" do
      connection = Faraday.new
      client = described_class.new(connection)
      expect(connection).to eq client.connection
    end
  end

  describe "#execute_request", vcr: false do
    context "headers" do
      it "should support literal headers" do
        stub_request(:post, "#{OpenGuilds.api_base}/v1/users")
          .with(headers: { "stub" => "true" })
          .to_return(body: JSON.generate(object: "user"))

        client = described_class.new
        client.execute_request(:post, "/v1/users",
                               headers: { stub: "true" })
      end

      it "should support RestClient-style header keys" do
        stub_request(:post, "#{OpenGuilds.api_base}/v1/users")
          .with(headers: { "stub" => "true" })
          .to_return(body: JSON.generate(object: "user"))

        client = described_class.new
        client.execute_request(:post, "/v1/users",
                               headers: { stub: "true" })
      end
    end

    context 'with bad params' do
      it 'should raise an error' do
        stub_request(:post, "#{OpenGuilds.api_base}/v1/users")
          .with(headers: { "stub" => "true" })
          .to_return(body: '{ "user": "<div class="user">Ryan</div>" }')

        client = described_class.new
        expect{
        client.execute_request(:post, "/v1/users",
                               headers: { stub: "true" },
                               params: {})
        }.to raise_error OpenGuilds::APIError
      end
    end

    context 'with errors' do
      context 'when a client error' do
        it 'should return the error' do
          connection = double
          client = described_class.new(connection)
          allow(connection).to receive(:run_request)
            .and_raise(
              Faraday::Error::ClientError.new(
                "server responded with status 401", 
                {
                  status: 401,
                  headers: {},
                  body: { error: 'You are not authorized to perform this aciton or access this object. You may be trying to access an object you do not own, or have permission to modify.' }
                }
              )
            )

          expect{
            client.execute_request(
              :post, 
              "/v1/users",
              headers: { stub: "true" },
              params: {}
            )
          }.to raise_error OpenGuilds::AuthorizationError
        end
      end

      context 'with a record not found error' do
        it 'should return the error' do
          connection = double
          client = described_class.new(connection)
          allow(connection).to receive(:run_request)
            .and_raise(
              Faraday::Error::ClientError.new(
                "server responded with status 404", 
                {
                  status: 404,
                  headers: {},
                  body: { 
                    error: 'You are not authorized to perform this aciton or access this object. You may be trying to access an object you do not own, or have permission to modify.',
                    type: 'RecordNotFound'
                  }
                }
              )
            )

          expect{
            client.execute_request(
              :post, 
              "/v1/users",
              headers: { stub: "true" },
              params: {}
            )
          }.to raise_error OpenGuilds::RecordNotFoundError

        end
      end
    end
  end
end
