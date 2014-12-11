class SkroutzApi::Resource
  include SkroutzApi::Parsing

  attr_accessor :attributes, :client

  def initialize(attributes, client)
    @attributes = attributes
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

  protected

  def respond_to?(method, include_priv = false)
    method_name = method.to_s
    if attributes.nil?
      super
    elsif attributes.include?(method_name.sub(/[=\?]\Z/, ''))
      true
    else
      super
    end
  end

  def method_missing(method_symbol, *arguments)
    method_name = method_symbol.to_s

    if method_name =~ /(=|\?)$/
      case $1
      when '='
        attributes[$`] = arguments.first
      when '?'
        attributes[$`]
      end
    else
      return attributes[method_name] if attributes.include?(method_name)
      super
    end
  end
end
