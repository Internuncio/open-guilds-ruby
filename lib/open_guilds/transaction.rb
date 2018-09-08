module OpenGuilds
  class Transaction
    attr_reader :id, :type, :amount, :source, :amount_cents

    def initialize(params)
      @id = params[:id]
      @type = params[:type]
      @amount = params[:amount]
      @amount_cents = params[:amount_cents]
      @source = params[:source]
    end

    class << self
      def object_from(hash)
        self.new(hash)
      end
    end
  end
end
