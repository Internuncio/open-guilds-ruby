module Openguilds
  class Batch
    include HTTParty

    def initialize(params = {})
      @audio_url = params(:audio_url)
      raise ArgumentError if @audio_url.blank?
    end

    class << self
      def create(params)
        self.base_uri Openguilds.api_base

        response = self.post("/guild/4/batches",
          :headers => { 'Content-Type' => 'application/json' },
          :body => payload.to_json,
          :basic_auth => auth
        )

        return JSON.parse(response.body)
      end

      def get_batch(batch_id)
        self.base_uri Openguilds.api_base

        response = self.get("/batches/#{batch_id}",
          :headers => { 'Content-Type' => 'application/json' },
          :basic_auth => auth
        )

        return JSON.parse(response.body)
      end

      #Note: api DELETE, is not available now.
      def cancel_batch(batch_id)
        self.base_uri Openguilds.api_base

        response = self.delete("/batches/3",
          :headers => { 'Content-Type' => 'application/json' },
          :basic_auth => auth
        )

        return JSON.parse(response.body)
      end

      def pay_for_a_batch(batch_id)
        self.base_uri Openguilds.api_base

        response = self.post(
          "/batches/#{batch_id}/debits/",
          :headers => { 'Content-Type' => 'application/json' },
          :basic_auth => auth
        )

        return response
      end

      private

      def payload
        {
          batch: {
            data: [
              { audio_url: @audio_url }
            ]
          }
        }
      end

      def auth
        {
          username: Openguilds.api_key,
          password: ''
        }
      end
    end
  end
end
