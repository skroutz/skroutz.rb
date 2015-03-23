module Skroutz
  # = Skroutz Errors
  #
  # Generic Skroutz exception class.
  class SkroutzError < StandardError; end

  # Raised when Skroutz handles a non-successful response
  class ServerError < SkroutzError
    def initialize(status, body)
      super %Q(status: #{status}, body: "#{body}")
    end
  end

  # Raised when Skroutz can't parse the response for the resource
  class InvalidResource < SkroutzError
    def initialize(resource, body)
      super %Q(resource: #{resource}, body: "#{body}")
    end
  end

  # Raised when Skroutz doesn't find the requested resource
  class ResourceNotFound < SkroutzError
    def initialize(status, body)
      super %Q(status: #{status}, body: "#{body}")
    end
  end

  class TimeoutError < SkroutzError
    def initialize
      super 'The server did not produce a response within the configured time to wait'
    end
  end

  class ErrorHandler < Faraday::Response::Middleware
    def on_complete(env)
      case env[:status]
      when 404, 410
        raise Skroutz::ResourceNotFound.new(env.status, env.body)
      when 500...600
        raise Skroutz::ServerError.new(env.status, env.body)
      end
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