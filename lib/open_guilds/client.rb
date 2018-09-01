module OpenGuilds
  class Client
    attr_accessor :connection

    def initialize(connection = nil)
      @connection = connection ||= OpenGuilds::Client.default_connection
    end


    def self.default_connection
      Faraday.new do |c|
        c.use Faraday::Request::Multipart
        c.use Faraday::Request::UrlEncoded
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

      params = Util.objects_to_ids(params)
      url = api_url(path, api_base)

      body = nil
      query_params = nil

      case method.to_s.downcase.to_sym
      when :get, :head, :delete
        query_params = params
      else
        body = if headers[:content_type] && headers[:content_type] == "multipart/form-data"
                 params
               else
                 Util.encode_parameters(params)
               end
      end

      # This works around an edge case where we end up with both query
      # parameters in `query_params` and query parameters that are appended
      # onto the end of the given path. In this case, Faraday will silently
      # discard the URL's parameters which may break a request.
      #
      # Here we decode any parameters that were added onto the end of a path
      # and add them to `query_params` so that all parameters end up in one
      # place and all of them are correctly included in the final request.
      u = URI.parse(path)
      unless u.query.nil?
        query_params ||= {}
        query_params = Hash[URI.decode_www_form(u.query)].merge(query_params)

        # Reset the path minus any query parameters that were specified.
        path = u.path
      end

      headers = request_headers(api_key, method)
                .update(Util.normalize_headers(headers))

      http_resp = connection.run_request(method, url, body, headers) do |req|
        req.options.open_timeout = OpenGuilds.open_timeout
        req.options.timeout = OpenGuilds.read_timeout
        req.params = query_params unless query_params.nil?
      end

      begin
        resp = OpenGuilds::Response.from_faraday_response(http_resp)
      rescue JSON::ParserError
        raise general_api_error(http_resp.status, http_resp.body)
      end

      # Allows StripeClient#request to return a response object to a caller.
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
        "Authorization" => "Bearer #{api_key}",
        "Content-Type" => "application/json",
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
  end
end
