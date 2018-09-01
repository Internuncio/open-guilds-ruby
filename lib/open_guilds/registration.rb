module Openguilds
  class Registration
    include HTTParty

    def self.register(params)

      response = self.post(
        "/register",
        :query => {
          email: params[:email],
          password: params[:password],
          password_confirmation: params[:password_confirmation]
        }
      )

      return JSON.parse(response.body)
    end
  end
end
