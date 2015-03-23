class Skroutz::CollectionProxy
  include Skroutz::Parsing
  include Skroutz::UrlHelpers

  attr_accessor :client, :owner

  def initialize(client, owner = nil)
    @client = client
    @owner = owner
  end

  def find(id, options = {})
    response = client.get("#{base_path}/#{id}")

    return parse(response) unless block_given?

    yield response
  end

  def page(pagenum = 1, options = {})
    per = options[:per] || client.config[:pagination_page_size]
    response = client.get(base_path, page: pagenum, per: per)

    return parse(response) unless block_given?

    yield response
  end

  def all(options = {})
    response = client.get(base_path)

    return parse(response) unless block_given?

    yield response
  end

  def resource
    @resource ||= self.class.to_s.demodulize.chomp('Collection').downcase.singularize
  end

  def resource_prefix
    @resource_prefix ||= resource.pluralize
  end

  def model_name
    @model_name ||= "Skroutz::#{resource.classify}".constantize
  end
end
