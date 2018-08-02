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

      def purchase_credits(stripe_params)
        self.base_uri Openguilds.api_base

        response = self.post(
          "/wallet/credits/",
          :headers => { 'Content-Type' => 'application/json' },
          :basic_auth => auth,
          :query => {
            "email" => stripe_params["email"],
            "token" => stripe_params["token"],
            "amount" => stripe_params["amount"]
          }
        )

        return JSON.parse(response)
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
