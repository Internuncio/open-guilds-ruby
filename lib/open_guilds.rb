require "json"

require "open_guilds/version"
require "open_guilds/errors"

require "open_guilds/client"

require "open_guilds/util"
require "open_guilds/response"
require "open_guilds/api_resource"

require "open_guilds/batch"
require "open_guilds/datum"
require "open_guilds/registration"
require "open_guilds/transaction"
require "open_guilds/wallet"


module OpenGuilds
  @api_base = 'https://testing.openguilds.com/api'
  @max_network_retry_delay = 2
  @initial_network_retry_delay = 0.5
  @max_network_retries = 0

  @open_timeout = 30
  @read_timeout = 80

  class << self
    attr_accessor :api_version, :api_base, :api_key, :max_network_retries,
      :open_timeout, :read_timeout

    attr_reader :max_network_retry_delay, :initial_network_retry_delay
  end
end
