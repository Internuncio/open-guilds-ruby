require 'dotenv/load'

require "rspec"
require "byebug"
require 'webmock/rspec'
require "faraday"
require "open_guilds"
require File.expand_path("../test_data", __FILE__)
require "socket"
require 'capybara/rspec'
require "cuba/capybara"
require "rack/test"


WebMock.disable_net_connect!(allow_localhost: true)

RSpec.configure do |config|
  OpenGuilds.api_key = ENV["LIVE_TEST_KEY"]
  OpenGuilds.api_base = 'http://localhost:8080/api'

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  def with_fake_server(example)
    # Set the API endpoint to the fake server,
    # saving the current value for later
    old_api_endpoint = ENV['API_ENDPOINT']
    ENV['API_ENDPOINT'] = 'http://localhost:8080/api'

    # Boolean to check whether the server has started. This will
    # be flipped later.
    server_started = false

    # Start the server in a new thread, so we don't block execution
    # and can actually run our tests in this thread.
    begin
      sock = Socket.new(Socket::Constants::AF_INET, Socket::Constants::SOCK_STREAM, 0);
      sock.bind(Socket.pack_sockaddr_in(8080, '0.0.0.0'));
      Thread.new do
        require_relative '../servers/mock_api_server.rb'
        Rack::Handler::WEBrick.run(
          Cuba,
          Logger: WEBrick::Log.new(File.open(File::NULL, 'w')),
          AccessLog: [],
          StartCallback: -> { server_started = true }
        )
      end
    rescue Errno::EADDRINUSE;
      server_started = true
    end

    # Wait until we know the server is ready
    sleep(0.1) until server_started

    # Run our tests
    example.run

    # Switch the API_ENDPOINT back to what it was before
    ENV['API_ENDPOINT'] = old_api_endpoint
  end

end
