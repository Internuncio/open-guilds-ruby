require "bundler/setup"
require "openguilds"
require "rspec"
require "webmock"
require "vcr"
require "byebug"
require "pry"
require "pry-byebug"
require 'openguilds/openguild'
require 'openguilds/error'
require 'openguilds/errors'

RSpec.configure do |config|
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
end
