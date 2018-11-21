require 'spec_helper'
require "cuba"
require File.expand_path("../../../servers/mock_api_server", __FILE__)

RSpec.describe 'Endpoints' do
  def app
    Cuba
  end

  invite_params = 
    { email: 'email@example.com' }

  batch_params =
    {
      "batch": {
        "data": [
          { "image_url": "www.images.com/image1.png", },
          { "image_url": "www.images.com/image2.png", },
          { "image_url": "www.images.com/image3.png", },
        ],
        "webhooks": [
          {
            "destination": "https://your.service.com", 
            "secret": "secret123",
          },
        ]
      }
    }

  debit_params =
    {}


  get_paths = %w(
    api/guilds
    api/guilds/1
    api/guilds/1/members
    api/guilds/1/members/find?email="email@example.com"
    api/batches
    api/batches/1
    api/tasks
    api/tasks/1
    api/members/1
  )

  delete_paths = %w(
    api/batches/1
    api/members/1
  )

  post_paths = [
    { path: "api/guilds/1/invites", params: invite_params },
    { path: "api/guilds/1/batches", params: batch_params },
    { path: "api/batches/1/debits", params: debit_params }
  ]

  describe 'GET Endpoints' do
    get_paths.each do |path|
      describe path do
        it 'should return a successful status' do
          get path

          expect(last_response.status).to eq 200
        end
      end
    end
  end

  describe "POST Endpoints" do
    post_paths.each do |hash|
      describe hash[:path] do
        it 'should return a successful status' do
          post hash[:path], hash[:params]

          expect(last_response.status).to eq 200
        end
      end
    end
  end

  describe "DELETE Endpoints" do
    delete_paths.each do |path|
      describe path do
        it 'should return a successful status' do
          delete path

          expect(last_response.status).to eq 200
        end
      end
    end
  end

end
