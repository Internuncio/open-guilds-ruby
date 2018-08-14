module Openguilds
  class Guild
    include HTTParty

    class << self
      def get_guild(params)
        self.base_uri Openguilds.api_base
        response = self.get("/guilds/#{params[:guild_id]}",
          :headers => { 'Content-Type' => 'application/json' },
          :basic_auth => auth(params[:api_key])
        )

        return JSON.parse(response.body)
      end

      private

      def auth(api_key)
        {
          username: api_key,
          password: ''
        }
      end
    end

  end
end
