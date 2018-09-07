module OpenGuilds
  class Wallet < APIResource
    attr_reader :id, :balance, :transactions

    def initialize(params)
      @id = params[:id]
      @balance = params[:balance]
      @transactions = params[:transactions].map { 
        |transaction| OpenGuilds::Transaction.object_from(transaction) 
      }
    end

    class << self
      def object_from(params)
        self.new(params)
      end

      def get()
        response, key = client.execute_request(
          :get,
          "/wallet"
        )

        return self.object_from(response.data)
      end
    end
  end
end
