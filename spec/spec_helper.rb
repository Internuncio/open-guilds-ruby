require "bundler/setup"
require "open_guilds"
require "rspec"
require "webmock"
require 'webmock/rspec'
require "vcr"
require "byebug"
require "pry"
require "faraday"
require "pry-byebug"
require 'open_guilds/error'
require 'open_guilds/errors'
require 'open_guilds/authentication'
require File.expand_path("../test_data", __FILE__)

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:suite) do
    OpenGuilds.api_key = "test_123"
  end
end

VCR.configure do |config|
  config.cassette_library_dir = "spec/cassettes"
  config.hook_into :webmock
  config.configure_rspec_metadata!
end
