module OpenGuilds
  class Batch < APIResource
    class << self
      def create(guild_id, params)
        response, key = client.execute_request(
          :post,
          "/guild/#{guild_id}/batches",
          :params => params
        )

        return response
      end

      def get(batch_id)
        response, key = client.execute_request(
          :get,
          "/batches/#{batch_id}"
        )

        return response
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
