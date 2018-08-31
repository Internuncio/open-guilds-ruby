module Openguilds
  class Batch
    include HTTParty

    def initialize(params = {})
      @audio_url = params.feth(:audio_url, '')
      raise ArgumentError if @audio_url.blank?
    end

    class << self
      def create(params)
        self.base_uri Openguilds.api_base

        response = self.post("/guild/2/batches",
          :headers => { 'Content-Type' => 'application/json' },
          :body => payload.to_json,
          basic_auth: auth
        )

        Openguilds.construct_from(response)
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
