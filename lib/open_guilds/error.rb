module Openguilds
  class Error
    attr_reader :error, :status

    def initialize(params)
      @error = params[:error]
      @status = params[:status]

      if @error.match /Invalid Token/
        raise Openguilds::APIKeyIncorrect, "You API key is incorrect."
      end
    end
  end
end
