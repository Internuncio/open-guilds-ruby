require "bundler/setup"
require "openguilds"
require "rspec"
require "webmock"
require "vcr"
require "byebug"
require "pry"
require "pry-byebug"
require 'openguilds/error'
require 'openguilds/errors'
require 'openguilds/authentication'
require 'stripe_mock'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:each) do
    @stripe_test_helper = StripeMock.create_test_helper
    StripeMock.start
  end

  config.after(:each) do
    StripeMock.stop
  end
end

VCR.configure do |config|
  config.cassette_library_dir = "spec/cassettes"
  config.hook_into :webmock
end
