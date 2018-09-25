module OpenGuilds
  class Datum < APIResource
    attr_reader :parameters

    def initialize(params)
      @id = params[:id]
      @parameters = params[:parameters]
    end
  end
end
