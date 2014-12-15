module SkroutzApi
  # = SkroutzApI Errors
  #
  # Generic SkroutzApi exception class.
  class SkroutzApiError < StandardError; end

  # Raised when SkroutzApi handles a non-successful response
  class ResourceNotFound < SkroutzApiError
    def initialize(response)
      super %Q(status: #{response.status}, body: "#{response.body}")
    end
  end
end
