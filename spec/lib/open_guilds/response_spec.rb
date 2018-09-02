require 'spec_helper'

RSpec.describe OpenGuilds::Response do
  describe '#from_faraday_hash' do
    it 'should convert to a OpenGuilds Response object' do
      body = '{"foo": "bar"}'
      headers = { "Request-Id" => "request-id" }

      http_resp = {
        body: body,
        headers: headers,
        status: 200,
      }

      resp = OpenGuilds::Response.from_faraday_hash(http_resp)

      expect(resp.data).to eq JSON.parse(body, symbolize_names: true)
      expect(resp.http_body).to eq body
      expect(resp.http_headers).to eq headers
      expect(resp.http_status).to eq 200
      expect(resp.request_id).to eq 'request-id'
    end
  end

  describe 'from_faraday_response' do
    it 'should convert to a OpenGuilds Response object' do
      body = '{"foo": "bar"}'
      headers = { "Request-Id" => "request-id" }

      env = Faraday::Env.from(
        status: 200, body: body,
        response_headers: headers
      )
      http_resp = Faraday::Response.new(env)

      resp = OpenGuilds::Response.from_faraday_response(http_resp)

      expect(resp.data).to eq JSON.parse(body, symbolize_names: true)
      expect(resp.http_body).to eq body
      expect(resp.http_headers).to eq headers
      expect(resp.http_status).to eq 200
      expect(resp.request_id).to eq 'request-id'
    end
  end
end
