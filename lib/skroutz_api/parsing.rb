module SkroutzApi::Parsing
  def parse_body(response)
    model_name.new((JSON.parse response.body)[resource_prefix.singularize], client)
  end

  def parse_array(response, resource_prefix)
    (JSON.parse response.body)[resource_prefix].map do |resource|
      model_name.new(resource, client)
    end
  end

  def link_header(response)
    response.headers['link'].split(',').reduce({}) do |h, link|
      page, type = link.scan(/\<(.*)\>; rel="(.*)"/).flatten
      h[type.to_sym] = page

      h
    end
  end
end
