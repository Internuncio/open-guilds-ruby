require 'dotenv/load'

require "rspec"
require "byebug"
require 'webmock/rspec'
require "vcr"
require "faraday"
require "open_guilds"
require File.expand_path("../test_data", __FILE__)

RSpec.configure do |config|
  OpenGuilds.api_key = ENV["LIVE_TEST_KEY"]

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

VCR.configure do |config|
  config.cassette_library_dir = "spec/cassettes"
  config.hook_into :webmock
  config.configure_rspec_metadata!
  config.default_cassette_options = { :record => :new_episodes }
end
