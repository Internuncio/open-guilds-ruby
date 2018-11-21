module OpenGuilds
  class Guild < APIResource
    attr_reader :id, :name, :description, :price_floor, :price_floor_cents

    def initialize(params)
      @id = params[:id]
      @name = params[:name]
      @description = params[:description]
      @price_floor = params[:price_floor]
      @price_floor_cents = params[:price_floor_cents]
    end

    class << self
      def get(guild_id)
        response, key = client.execute_request(
          :get,
          "/guilds/#{guild_id}"
        )

        return Util.object_from(response.data)
      end

      def list
        response, key = client.execute_request(
          :get,
          "/guilds"
        )

        return Util.object_from(response.data)
      end
    end
  end
end
