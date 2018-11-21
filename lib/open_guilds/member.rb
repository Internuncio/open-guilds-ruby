module OpenGuilds
  class Member < APIResource
    attr_reader :id, :email, :quality_score, :credit, :credit_cents

    def initialize(params)
      @values = params
      @id = params[:id]
      @email  = params[:email]
      @quality_score = params[:quality_score]
      @credit = params[:credit]
      @credit_cents = params[:credit_cents]
    end

    def deleted?
      @values.fetch(:deleted, false)
    end

    class << self
      def get(member_id)
        response, key = client.execute_request(
          :get,
          "/members/#{member_id}"
        )

        return Util.object_from(response.data)
      end

      def list(guild_id)
        response, key = client.execute_request(
          :get,
          "/guilds/#{guild_id}/members"
        )

        return Util.object_from(response.data)
      end

      def find(guild:, email:)
        response, key = client.execute_request(
          :get,
          "/guilds/#{guild}/members/find?email=#{email}"
        )

        return Util.object_from(response.data)
      end

      def invite(guild:, email:)
        response, key = client.execute_request(
          :post,
          "/guilds/#{guild}/invites",
          params: { email: email }
        )

        return Util.object_from(response.data)
      end

      def remove(member_id)
        response, key = client.execute_request(
          :delete,
          "/members/#{member_id}"
        )

        return Util.object_from(response.data)
      end
    end
  end
end
