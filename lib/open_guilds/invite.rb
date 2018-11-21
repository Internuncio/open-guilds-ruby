module OpenGuilds
  class Invite
    attr_reader :email, :status

    def initialize(params)
      @status = params[:status]
      @email = params[:email]
    end
  end
end
