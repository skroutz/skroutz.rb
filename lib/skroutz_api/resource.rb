class SkroutzApi::Resource
  include SkroutzApi::Parsing

  attr_accessor :client

  def initialize(client)
    @client = client
  end

  def find(id, options = {})
    response = client.get("#{resource_prefix}/#{id}")

    return parse_body(response) unless block_given?

    yield response
  end

  def page(pagenum = 1, options = {})
    per = options[:per] || client.config[:pagination_page_size]
    response = client.get(resource_prefix, page: pagenum, per: per)

    return SkroutzApi::PaginatedCollection.new(self, response) unless block_given?

    yield response
  end

  def all(options = {})
    response = client.get(resource_prefix)

    return SkroutzApi::PaginatedCollection.new(self, response) unless block_given?

    yield response
  end

  def resource_prefix
    @resource_prefix ||= self.class.to_s.demodulize.downcase.pluralize
  end
end
