module Openguilds
  class Wallet
    include HTTParty

    class << self
      def get_wallet
        self.base_uri Openguilds.api_base

        response = self.get(
          '/wallet/',
          :headers => { 'Content-Type' => 'application/json' },
          :basic_auth => auth
        )

        return JSON.parse(response.body)
      end

      private

      def auth
        {
          username: Openguilds.api_key,
          password: ''
        }
      end
    end
  end
end
