module Openguilds
  class Client
    include HTTParty

    def initialize(params = {})
      @api_token = params[:api_token]
      raise ArgumentError if @api_token.nil?
    end

    def self.authorize!(api_token)
      self.base_uri Openguilds.api_base

      if api_token.nil?
        raise ArgumentError
      end

      Openguilds::Client.new({ api_token: api_token })
    end
  end
end
