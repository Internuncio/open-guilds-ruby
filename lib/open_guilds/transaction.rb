module OpenGuilds
  class Transaction
    attr_reader :id, :type, :amount, :source

    def initialize(params)
      @id = params[:id]
      @type = params[:type]
      @amount = params[:amount]
      @source = params[:source]
    end

    class << self
      def object_from(hash)
        self.new(hash)
      end
    end
  end
end
