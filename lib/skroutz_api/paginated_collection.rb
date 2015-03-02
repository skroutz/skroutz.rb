class SkroutzApi::PaginatedCollection < Array
  include SkroutzApi::Parsing

  attr_reader :response, :context

  def initialize(context, response)
    @context = context
    @response = response
    super(parse_body(response)[context.resource_prefix])
  end

  def is_at_first?
    !first?
  end

  def is_at_last?
    !last?
  end

  %w[first last next previous].each do |meth|
    define_method "#{meth}?" do
      link_header(response).key? meth.to_sym
    end

    define_method "#{meth}_page" do
      return [] if !self.send("#{meth}?")
      target_query = URI.parse(link_header(response)[meth.to_sym]).query
      target_uri = URI.parse(context.resource_prefix)
      target_uri.query = target_query

      response = context.client.get(target_uri)

      return SkroutzApi::PaginatedCollection.new(context, response) unless block_given?

      yield response
    end
  end
end
