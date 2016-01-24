# Handles pagination in collections
#
# @example
#    client = Skroutz::Client.new(client_id, client_secret)
#    categories = client.categories.all
#    categories.next_page
class Skroutz::PaginatedCollection < Array
  include Skroutz::Parsing

  delegate :model_name, :client, to: :context

  attr_reader :response, :context

  # @param [Skroutz::Collection] context a collection
  # @param [Faraday::Response] response the HTTP response
  # @param [Array] collection the parsed collection of {Skroutz::Resource} instances
  def initialize(context, response, collection)
    @context = context
    @response = response

    super(collection)
  end

  # @return [true|false] True if on the first page, otherwise false
  def first_page?
    !first?
  end

  # @return [true|false] True if on the last page, otherwise false
  def last_page?
    !last?
  end

  # Page traversing methods and predicates
  %w[first last next previous].each do |meth|
    define_method "#{meth}?" do
      link_header(response).key? meth.to_sym
    end

    define_method "#{meth}_page" do |options = {}|
      return unless send("#{meth}?")

      target_uri = link_header(response)[meth.to_sym]
      gateway = context.respond_to?(:get) ? context : context.client

      response = gateway.get(target_uri, options)

      return parse(response) unless block_given?

      yield response
    end
  end


  # Retrieves response metadata
  # @return [HashWithIndifferentAccess] metadata
  def meta
    @meta ||= parse_meta(response)
  end
end
