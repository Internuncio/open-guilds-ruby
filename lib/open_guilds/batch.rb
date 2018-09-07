module OpenGuilds
  class Batch < APIResource
    attr_reader :fraction_completed, :completed, :status

    def initialize(params)
      @fraction_completed = params[:fraction_completed]
      @completed = params[:completed]
      @status = params[:status]
    end

    class << self
      def object_from(hash)
        self.new(hash)
      end

      def create(guild_id, params)
        response, key = client.execute_request(
          :post,
          "/guild/#{guild_id}/batches",
          :params => params
        )

        return self.object_from(response.data)
      end

      def get(batch_id)
        response, key = client.execute_request(
          :get,
          "/batches/#{batch_id}"
        )

        return self.object_from(response.data)
      end

      def cancel(batch_id)
        response, key = client.execute_request(
          :get,
          "/batches/#{batch_id}"
        )

        return response
      end
    end
  end
end
