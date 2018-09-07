module OpenGuilds
  class Registration
    def self.register(params)

      response = self.execute_request(
        :post,
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
