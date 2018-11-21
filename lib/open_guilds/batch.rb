module OpenGuilds
  class Batch < APIResource
    attr_reader :fraction_completed, :completed, :status, :id, :data

    def initialize(params)
      @values = params
      @id = params[:id]
      @data_completed_count = params.fetch(:data_completed_count, 0)
      @data_count = params.fetch(:data_count, 0)
      @status = params.fetch(:status, 'Canceled')
      @data = get_data_from_values
    end

    def canceled?
      @values.fetch(:canceled, false)
    end

    class << self

      def list
        response, key = client.execute_request(
          :get,
          "/batches"
        )

        return Util.object_from(response.data)
      end

      def cancel(batch_id)
        response, key = client.execute_request(
          :delete,
          "/batches/#{batch_id}"
        )

        return Util.object_from(response.data)
      end

      def create(guild:, params:)
        response, key = client.execute_request(
          :post,
          "/guilds/#{guild}/batches",
          params: params
        )

        return Util.object_from(response.data)
      end

      def pay(batch_id)
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

    private

    def get_data_from_values
      @values.fetch(:data, [])
        .map { |datum| OpenGuilds::Util.object_from(datum) }
    end
  end
end
