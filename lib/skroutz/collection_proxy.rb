class Skroutz::CollectionProxy
  include Skroutz::Parsing
  include Skroutz::UrlHelpers

  attr_accessor :id, :client, :owner

  # @param [Integer] id the id of a parent resource
  # @param [Skroutz::Client] client an instance of the client
  # @param [Skroutz::Resource] owner a parent resource
  # @param [Hash] options hints on how to construct the request path
  def initialize(id, client, owner = nil, options = {})
    if self.class == Skroutz::CollectionProxy
      raise RuntimeError.new('Attempted to initialize an abstract class')
    end

    @id = id
    @client = client
    @owner = owner
    @prefix = options[:prefix]
  end

  # Retrieves a single resource
  # @param [Integer] id the resource id
  # @param [Hash] options any options to pass down to the request object
  # @yield [Faraday::Response] the actual response
  # @return [Skroutz::Resource] the parsed response
  def find(id, options = {})
    response = client.get("#{base_path}/#{id}", options)

    return parse(response) unless block_given?

    yield response
  end

  # Retrieves a specific page of a collection
  # @param [Integer] pagenum the page to request
  # @param [Hash] options any options to pass down to the request object
  # @yield [Faraday::Response] the actual response
  # @return [Skroutz::PaginatedCollection] the parsed response
  def page(pagenum = 1, options = {})
    per = options[:per] || client.config[:pagination_page_size]
    response = client.get(base_path, { page: pagenum, per: per }.merge(options))

    return parse(response) unless block_given?

    yield response
  end

  # Retrieves a collection of resources
  # @param [Integer] pagenum the page to request
  # @param [Hash] options any options to pass down to the request object
  # @yield [Faraday::Response] the actual response
  # @return [Skroutz::PaginatedCollection] the parsed response
  def all(options = {})
    response = client.get(base_path, options)

    return parse(response) unless block_given?

    yield response
  end

  # @return [String] The name of the proxied resource
  def resource
    @resource ||= self.class.to_s.demodulize.chomp('Collection').tableize.singularize
  end

  # @return [String] The RESTful path segment of the proxied resource
  def resource_prefix
    @resource_prefix ||= @prefix || resource.pluralize
  end

  # @return [Skroutz::Resource] the resource class to use for parsing
  def model_name
    @model_name ||= "Skroutz::Resources::#{resource.classify}".constantize
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
