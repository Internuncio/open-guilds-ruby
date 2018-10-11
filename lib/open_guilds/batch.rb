module OpenGuilds
  class Batch < APIResource
    attr_reader :fraction_completed, :completed, :status, :id, :data

    def initialize(params)
      @id = params[:id]
      @fraction_completed = params[:fraction_completed]
      @completed = params[:completed]
      @status = params[:status]
      @data = params[:data].map {|datum| OpenGuilds::Util.object_from(datum)}
    end

    class << self

      def cancel(batch_id)
        response, key = client.execute_request(
          :delete,
          "/batches/#{batch_id}"
        )

        return Util.object_from(response.data)
      end

      def create(guild_id, params)
        response, key = client.execute_request(
          :post,
          "/guilds/#{guild_id}/batches",
          params: params
        )

        return Util.object_from(response.data)
      end

      def fund(batch_id)
        response, key = client.execute_request(
          :post,
          "/batches/#{batch_id}/debits"
        )

        return Util.object_from(response.data)
      end

      def get(batch_id)
        response, key = client.execute_request(
          :get,
          "/batches/#{batch_id}"
        )

        return Util.object_from(response.data)
      end
    end
  end
end
