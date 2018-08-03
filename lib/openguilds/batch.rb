module Openguilds
  class Batch
    include HTTParty

    class << self
      def create(params)
        self.base_uri Openguilds.api_base

        response = self.post("/guild/#{params[:guild_id]}/batches",
          :headers => { 'Content-Type' => 'application/json' },
          :body => params[:data].to_json,
          :basic_auth => auth(params[:api_key])
        )

        return JSON.parse(response.body)
      end

      def get_batch(params)
        self.base_uri Openguilds.api_base

        response = self.get("/batches/#{params[:batch_id]}",
          :headers => { 'Content-Type' => 'application/json' },
          :basic_auth => auth(params[:api_key])
        )

        return JSON.parse(response.body)
      end

      #Note: api DELETE, is not available now.
      def cancel_batch(params)
        self.base_uri Openguilds.api_base

        response = self.delete("/batches/#{params[:batch_id]}",
          :headers => { 'Content-Type' => 'application/json' },
          :basic_auth => auth(params[:api_key])
        )

        return JSON.parse(response.body)
      end

      def pay_for_a_batch(params)
        self.base_uri Openguilds.api_base

        response = self.post(
          "/batches/#{params[:batch_id]}/debits/",
          :headers => { 'Content-Type' => 'application/json' },
          :basic_auth => auth(params[:api_key])
        )

        return JSON.parse(response.body)
      end

      private

      def auth(api_key)
        {
          username: api_key,
          password: ''
        }
      end
    end
  end
end
