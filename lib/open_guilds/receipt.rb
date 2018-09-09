require 'money'
I18n.enforce_available_locales = false

module OpenGuilds
  class Receipt
    attr_reader :line_items, :total_cents

    def initialize()
      @line_items = []
      @total_cents = 0
    end

    def total_cents
      line_items.map(&:amount_cents).inject(0, :+)
    end

    def total
      Money.new(total_cents).format
    end

    class LineItem
      attr_reader :amount_cents

      def initialize(params)
        @amount_cents = params[:amount_cents]
      end
    end
  end
end
