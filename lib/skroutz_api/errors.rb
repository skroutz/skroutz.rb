module SkroutzApi
  # = SkroutzApI Errors
  #
  # Generic SkroutzApi exception class.
  class SkroutzApiError < StandardError; end

  # Raised when SkroutzApi handles a non-successful response
  class ServerError < SkroutzApiError
    def initialize(status, body)
      super %Q(status: #{status}, body: "#{body}")
    end
  end

  # Raised when SkroutzApi doesn't find the requested resource
  class ResourceNotFound < SkroutzApiError
    def initialize(response)
      super %Q(status: #{response.status}, body: "#{response.body}")
    end
  end

  class ErrorHandler < Faraday::Response::Middleware
    def on_complete(env)
      case env[:status]
      when 500...600
        raise SkroutzApi::ServerError.new(env.status, env.body)
      end
    end
  end
end
