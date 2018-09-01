module OpenGuilds
  module TestData
    def self.make_error(type, message)
      {
        error: {
          type: type,
          message: message,
        },
      }
    end

    def self.make_invalid_api_key_error
      {
        error: {
          type: "invalid_request_error",
          message: "Invalid API Key provided: invalid",
        },
      }
    end

    def self.make_missing_id_error
      {
        error: {
          param: "id",
          type: "invalid_request_error",
          message: "Missing id",
        },
      }
    end

    def self.make_rate_limit_error
      {
        error: {
          type: "invalid_request_error",
          message: "Too many requests in a period of time.",
        },
      }
    end

    def self.make_api_error
      {
        error: {
          type: "api_error",
        },
      }
    end
  end
end
