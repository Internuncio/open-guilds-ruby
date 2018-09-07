module OpenGuilds
  class APIResource
    def self.client
      OpenGuilds::Client.new()
    end
  end
end
