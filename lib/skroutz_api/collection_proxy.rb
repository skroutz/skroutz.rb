class SkroutzApi::CollectionProxy
  include SkroutzApi::Parsing
  include SkroutzApi::UrlHelpers

  attr_accessor :client, :owner

  def initialize(client, owner = nil)
    @client = client
    @owner = owner
  end

  def find(id, options = {})
    response = client.get("#{base_path}/#{id}")

    return parse_body(response) unless block_given?

    yield response
  end

  def page(pagenum = 1, options = {})
    per = options[:per] || client.config[:pagination_page_size]
    response = client.get(base_path, page: pagenum, per: per)

    return SkroutzApi::PaginatedCollection.new(self, response) unless block_given?

    yield response
  end

  def all(options = {})
    response = client.get(base_path)

    return SkroutzApi::PaginatedCollection.new(self, response) unless block_given?

    yield response
  end

  def resource
    @resource ||= self.class.to_s.demodulize.chomp('Collection').downcase.singularize
  end

  def resource_prefix
    @resource_prefix ||= resource.pluralize
  end

  def model_name
    @model_name ||= "SkroutzApi::#{resource.classify}".constantize
  end
end
