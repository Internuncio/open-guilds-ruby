module Openguilds
  class Authentication
    include HTTParty

    def self.basic_auth(params)
      self.base_uri Openguilds.api_base

      if params[:email].nil? or params[:password].nil?
        raise ArgumentError
      end

      response = self.post(
        "/authenticate",
        :query => {
          email: params[:email],
          password: params[:password]
        }
      )

      puts JSON.parse(response.body)["auth_token"]
      return {
        username: JSON.parse(response.body)["auth_token"],
        password: ""
      }
    end
  end
end
