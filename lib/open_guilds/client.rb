require 'base64'

module OpenGuilds
  class Client
    attr_accessor :connection

    def initialize(connection = nil)
      @connection = connection ||= OpenGuilds::Client.default_connection
    end


    def self.default_connection
      Faraday.new do |c|
        c.use Faraday::Request::Multipart
        c.use Faraday::Response::RaiseError
        c.adapter Faraday.default_adapter
      end
    end

    def self.should_retry?(error, num_retries)
      return false if num_retries >= OpenGuilds.max_network_retries

      # Retry on timeout-related problems (either on open or read).
      return true if error.is_a?(Faraday::TimeoutError)

      # Destination refused the connection, the connection was reset, or a
      # variety of other connection failures. This could occur from a single
      # saturated server, so retry in case it's intermittent.
      return true if error.is_a?(Faraday::ConnectionFailed)

      if error.is_a?(Faraday::ClientError) && error.response
        return true if error.response[:status] == 409
      end

      false
    end

    def self.sleep_time(num_retries)
      # Apply exponential backoff with initial_network_retry_delay on the
      # number of num_retries so far as inputs. Do not allow the number to exceed
      # max_network_retry_delay.
      sleep_seconds = [OpenGuilds.initial_network_retry_delay * (2**(num_retries - 1)), OpenGuilds.max_network_retry_delay].min

      # Apply some jitter by randomizing the value in the range of (sleep_seconds
      # / 2) to (sleep_seconds).
      sleep_seconds *= (0.5 * (1 + rand))

      # But never sleep less than the base sleep seconds.
      sleep_seconds = [OpenGuilds.initial_network_retry_delay, sleep_seconds].max

      sleep_seconds
    end

    # Executes the API call within the given block. Usage looks like:
    #
    #     client = OpenGuilds::Client.new
    #     object, resp = client.request { Batch.create }
    #
    def request
      @last_response = nil
      res = yield
      [res, @last_response]
    end

    def execute_request(method, path,
                        api_base: nil, api_key: nil, headers: {}, params: {})

      api_base ||= OpenGuilds.api_base
      api_key ||= OpenGuilds.api_key

      check_api_key!(api_key)

      url = api_url(path, api_base)

      headers = request_headers(api_key, method)
                .update(Util.normalize_headers(headers))

      case
      when params.is_a?(Hash)
        body = params.to_json
      when params.is_a?(JSON)
        body = params
      else
        body = params.to_json
      end

      begin

        http_resp = connection.run_request(method, url, body, headers) do |req|
          req.options.open_timeout = OpenGuilds.open_timeout
          req.options.timeout = OpenGuilds.read_timeout
        end

      rescue Faraday::Error::ClientError => e
        case
        when e.response[:status] == 422
          raise OpenGuilds::InvalidParametersError.new(
            JSON.parse(e.response[:body])["error"],
            http_status: e.response[:status],
            http_body: e.response[:body],
            json_body: e.response[:body],
            http_headers: e.response[:headers],
            code: e.response[:status]
          )
        when e.response[:status] == 401
          raise OpenGuilds::AuthorizationError.new(
            e.message,
            http_status: e.response[:status],
            http_body: e.response[:body],
            json_body: e.response[:body],
            http_headers: e.response[:headers],
            code: e.response[:status]
          )
        else
          raise general_api_error(e.message, e.response)
        end
      end

      begin
        resp = OpenGuilds::Response.from_faraday_response(http_resp)
      rescue JSON::ParserError
        raise general_api_error(http_resp.status, http_resp.body)
      end

      # Allows OpenGuilds::Client#request to return a response object to a caller.
      @last_response = resp
      [resp, api_key]
    end

    private

    def check_api_key!(api_key)
      unless api_key
        raise AuthenticationError, "No API key provided. " \
          'Set your API key using "Stripe.api_key = <API-KEY>". ' \
          "You can generate API keys from the Stripe web interface. " \
          "See https://stripe.com/api for details, or email support@stripe.com " \
          "if you have any questions."
      end

      return unless api_key =~ /\s/

      raise AuthenticationError, "Your API key is invalid, as it contains " \
        "whitespace. (HINT: You can double-check your API key from the " \
        "Stripe web interface. See https://stripe.com/api for details, or " \
        "email support@stripe.com if you have any questions.)"
    end

    def api_url(url = "", api_base = nil)
      (api_base || OpenGuilds.api_base) + url
    end

    def request_headers(api_key, method)
      headers = {
        "Authorization" => "Basic #{Base64.encode64(api_key)}",
        "Content-Type" => "application/json"
      }

      # It is only safe to retry network failures on post and delete
      # requests if we add an Idempotency-Key header
      if %i[post delete].include?(method) && OpenGuilds.max_network_retries > 0
        headers["Idempotency-Key"] ||= SecureRandom.uuid
      end

      if OpenGuilds.api_version
        headers["OpenGuilds-Version"] = OpenGuilds.api_version
      end

      return headers
    end

    def general_api_error(status, body)
      APIError.new("Invalid response object from API: #{body.inspect} " \
                   "(HTTP response code was #{status})",
                   http_status: status, http_body: body)
    end
  end
end
