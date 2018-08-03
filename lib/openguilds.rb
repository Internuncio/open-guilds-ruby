require "httparty"
require "json"
require "openguilds/version"
require "openguilds/errors"
require "openguilds/batch"
require "openguilds/registration"
require "openguilds/authentication"
require "openguilds/wallet"

module Openguilds
  @api_base = 'https://testing.openguilds.com/api'

  class << self
    attr_accessor :api_base

    def construct_from(response)
      parsed_response = response.parsed_response

      if parsed_response["data"]
        self.send("construct_data",
          parsed_response)
        else
          construct_error(parsed_response)
        end
      end

      def construct_data(parsed_response)
        {
          data: parsed_response['data'],
          webhooks: parsed_response['webhooks']
        }
      end

      def construct_error(parsed_response)
        error = parsed_response["error"]
        if error.nil?
          error = parsed_response["error"]
        end
        Openguilds::Error.new(
          error: error,
          status: parsed_response["status"]
        )
      end
  end
end
