module OpenGuilds
  class Datum < APIResource
    attr_reader :parameters

    def initialize(params)
      @id = params[:id]
      @parameters = params[:parameters]
    end

    class << self
      def object_from(hash)
        self.new(hash)
      end
    end
  end
end
