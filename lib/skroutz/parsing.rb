module Skroutz::Parsing
  # Parse a JSON response
  #
  # @raise Skroutz::InvalidResource when response contains invalid JSON
  # @param [Faraday::Response] the response object
  # @return [Skroutz::PaginatedCollection|Skroutz::Resource]
  def parse(response)
    json = JSON.parse(response.body)

    if collection?(json)
      Skroutz::PaginatedCollection.new(self, response, parse_collection(json))
    else
      parse_resource(json)
    end
  rescue JSON::ParserError
    raise Skroutz::InvalidResource.new(model_name.to_s, response.body)
  end

  # @param [Hash] a parsed JSON response
  # @return [Skroutz::Resource]
  def parse_resource(json)
    infer_model(json).new(json[resource_key(json)], client)
  end

  # @param [Hash] a parsed JSON response
  # @return [Skroutz::PaginatedCollection]
  def parse_collection(json)
    model_name = infer_collection(json)

    json[collection_resource_key(json).pluralize].map do |resource|
      model_name.new(resource, client)
    end
  end

  # @return [HashWithIndifferentAccess] the parsed metadata
  def parse_meta(response)
    HashWithIndifferentAccess.new(JSON.parse(response.body).fetch('meta', {}))
  end

  # Grabs URL links from the link header
  # @return [Hash] the parsed links
  def link_header(response)
    response.headers.fetch('link', '').split(',').reduce({}) do |h, link|
      page, type = link.scan(/\<(.*)\>; rel="(.*)"/).flatten
      h[type.to_sym] = page

      h
    end
  end

  # Grabs the root key of the singular JSON response
  # @return [String] the key
  def resource_key(json)
    json.keys.first
  end

  # Grabs the root key of the collection JSON response
  # @return [String] the key
  def collection_resource_key(json)
    (json.keys - ['meta']).first.singularize
  end

  # Tries to match a resource class for the singular response
  def infer_model(json)
    "Skroutz::#{resource_key(json).capitalize}".safe_constantize
  end

  # Tries to match a resource class for the collection response
  def infer_collection(json)
    "Skroutz::#{collection_resource_key(json).classify}".safe_constantize
  end

  # Tries to match a resource class for the collection response
  # Currently only collections contain metadata in a 'meta' key
  #
  # @return [true|false]
  def collection?(json)
    json[(json.keys - ['meta']).first].is_a?(Array)
  end
end
