require "faraday"
require "json"
require "openguilds/version"

module Openguilds
  @api_base = 'https://testing.openguilds.com/api'

  class << self
    attr_accessor :api_base, :api_key
  end
end
