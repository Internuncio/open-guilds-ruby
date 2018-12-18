module OpenGuilds
  class Wallet < APIResource
    attr_reader :id, :balance, :transactions

    def initialize(params)
      @values = params
      @id = params[:id]
      @balance = params[:balance]
      @transactions = get_transactions_from_values
    end

    class << self
      def object_from(params)
        self.new(params)
      end

      def list
        response, key = client.execute_request(
          :get,
          "/wallets"
        )

        return Util.object_from(response.data)
      end

      def get(id)
        response, key = client.execute_request(
          :get,
          "/wallets/#{id}"
        )

        return Util.object_from(response.data)
      end
    end

    private

    def get_transactions_from_values
      OpenGuilds::Transaction.object_from(
        @values.fetch(:transactions)
      )
    end
  end
end
