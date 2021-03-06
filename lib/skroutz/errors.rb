module Skroutz
  # = Skroutz Errors
  #
  # Generic Skroutz exception class.
  class SkroutzError < StandardError; end

  # Raised when a 4xx error occurs
  class ClientError < SkroutzError
    def initialize(status, body)
      super %(status: #{status}, body: "#{body}")
    end
  end

  # Raised when Skroutz handles a non-successful response
  class ServerError < SkroutzError
    def initialize(status, body)
      super %(status: #{status}, body: "#{body}")
    end
  end

  # Raised when Skroutz can't parse the response for the resource
  class InvalidResource < SkroutzError
    def initialize(resource, body)
      super %(resource: #{resource}, body: "#{body}")
    end
  end

  # Raised when Skroutz doesn't find the requested resource
  class ResourceNotFound < SkroutzError
    def initialize(status, body)
      super %(status: #{status}, body: "#{body}")
    end
  end

  class TimeoutError < SkroutzError
    def initialize
      super 'The server did not produce a response within the configured time to wait'
    end
  end

  # Raised when the rate-limiting is exceeded
  class RateLimitingError < SkroutzError; end

  # Raised when an authorization error occurs
  class UnauthorizedError < SkroutzError
    def initialize(status, body)
      super %(status: #{status}, body: "#{body}")
    end
  end

  class ErrorHandler < Faraday::Response::Middleware
    def on_complete(env)
      status = env[:status]

      return unless (400...600).include?(status)

      send("handle_#{status.to_s.gsub(/(\d\d)$/, 'xx')}", env)
    end

    private

    def handle_4xx(env) # rubocop:disable Metrics/AbcSize
      case env.status
      when 400
        raise Skroutz::ClientError.new(env.status, env.body)
      when 401
        raise Skroutz::UnauthorizedError.new(env.status, env.body)
      when 403
        raise Skroutz::RateLimitingError if rate_limited?(env)
        raise Skroutz::ClientError.new(env.status, env.body)
      when 404, 410
        raise Skroutz::ResourceNotFound.new(env.status, env.body)
      end
    end

    def handle_5xx(env)
      raise Skroutz::ServerError.new(env.status, env.body)
    end

    def rate_limited?(env)
      env.response_headers.fetch('x-ratelimit-remaining', 1).to_i <= 0
    end
  end

  class TimeoutHandler < Faraday::Middleware
    def initialize(app)
      super(app)
    end

    def call(env)
      @app.call(env)
      rescue Faraday::TimeoutError
        raise Skroutz::TimeoutError
    end
  end
end
