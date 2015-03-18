class SkroutzApi::PaginatedCollection < Array
  include SkroutzApi::Parsing

  delegate :model_name, :client, to: :context

  attr_reader :response, :context

  def initialize(context, response, collection)
    @context = context
    @response = response

    super(collection)
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

    define_method "#{meth}_page" do |options = {}|
      return if !self.send("#{meth}?")

      target_uri = link_header(self.response)[meth.to_sym]
      gateway = context.respond_to?(:get) ? context : context.client

      response = gateway.get(target_uri, options)

      return parse(response) unless block_given?

      yield response
    end
  end

  def meta
    @meta ||= parse_meta(response)
  end
end
