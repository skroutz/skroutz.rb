module SkroutzApi::Parsing
  def parse_body(response)
    JSON.parse response.body
  end

  def link_header(response)
    response.headers['link'].split(',').reduce({}) do |h, link|
      page, type = link.scan(/\<(.*)\>; rel="(.*)"/).flatten
      h[type.to_sym] = page

      h
    end
  end
end
