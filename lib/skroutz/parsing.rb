module Skroutz::Parsing
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

  def parse_resource(json)
    infer_model(json).new(json[resource_key(json)], client)
  end

  def parse_collection(json)
    model_name = infer_collection(json)

    json[collection_resource_key(json).pluralize].map do |resource|
      model_name.new(resource, client)
    end
  end

  def parse_meta(response)
    HashWithIndifferentAccess.new(JSON.parse(response.body).fetch('meta', {}))
  end

  def link_header(response)
    response.headers.fetch('link', '').split(',').reduce({}) do |h, link|
      page, type = link.scan(/\<(.*)\>; rel="(.*)"/).flatten
      h[type.to_sym] = page

      h
    end
  end

  def resource_key(json)
    json.keys.first
  end

  def collection_resource_key(json)
    (json.keys - ['meta']).first.singularize
  end

  def infer_model(json)
    "Skroutz::#{resource_key(json).capitalize}".safe_constantize
  end

  def infer_collection(json)
    "Skroutz::#{collection_resource_key(json).classify}".safe_constantize
  end

  def collection?(json)
    json[(json.keys - ['meta']).first].is_a?(Array)
  end
end
