class Skroutz::CollectionProxy
  include Skroutz::Parsing
  include Skroutz::UrlHelpers

  attr_accessor :id, :client, :owner

  def initialize(id, client, owner = nil, options = {})
    if self.class == Skroutz::CollectionProxy
      raise RuntimeError.new('Attempted to initialize an abstract class')
    end

    @id = id
    @client = client
    @owner = owner
    @prefix = options[:prefix]
  end

  def find(id, options = {})
    response = client.get("#{base_path}/#{id}", options)

    return parse(response) unless block_given?

    yield response
  end

  def page(pagenum = 1, options = {})
    per = options[:per] || client.config[:pagination_page_size]
    response = client.get(base_path, { page: pagenum, per: per }.merge(options))

    return parse(response) unless block_given?

    yield response
  end

  def all(options = {})
    response = client.get(base_path, options)

    return parse(response) unless block_given?

    yield response
  end

  def resource
    @resource ||= self.class.to_s.demodulize.chomp('Collection').tableize.singularize
  end

  def resource_prefix
    @resource_prefix ||= @prefix || resource.pluralize
  end

  def model_name
    @model_name ||= "Skroutz::#{resource.classify}".constantize
  end

  private

  def method_missing(method, *args) # rubocop:disable Metrics/CyclomaticComplexity
    options = args.first || {}
    url_prefix = options.delete(:url_prefix) || ''
    verb = options.delete(:verb) || options.delete(:via) || :get

    target_url = "#{base_path}/#{id}/#{method}"
    target_url.prepend("#{url_prefix}/") if url_prefix

    response = client.send(verb, target_url, options)

    return parse(response) unless block_given?

    yield response
  end
end
