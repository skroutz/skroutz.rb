# Parent class of all resources
class Skroutz::Resource
  include Skroutz::Associations

  attr_accessor :attributes, :client

  alias :to_hash :attributes

  # @param [Hash] attributes The attributes to initialize the resource with
  # @param [Skroutz::Client] client an instance of the client
  def initialize(attributes, client)
    @attributes = attributes
    @client = client
  end

  # @return [String] The name of the encapsulated resource
  def resource
    @resource ||= self.class.to_s.demodulize.tableize.singularize
  end

  # @return [String] The RESTful path segment of the resource
  def resource_prefix
    @resource_prefix ||= resource.pluralize
  end

  # @return [String] The attribute inspection of the instance
  def inspect
    if attributes.present?
      inspection = attributes.map { |k, v| "#{k}: #{attribute_for_inspect(v)}" }.join(', ')
    else
      inspection = 'not initialized'
    end

    "#<#{self.class} #{inspection}>"
  end

  protected

  def respond_to_missing?(method, include_priv = false)
    method_name = method.to_s
    if attributes.nil?
      super
    elsif attributes.include?(method_name.sub(/[=\?]\Z/, ''))
      true
    else
      super
    end
  end

  # Attribute accessors and boolean predicates
  # @example
  #    resource = Skroutz::Category,new(attrs, client)
  #    resource.active = false
  #    resource.active?
  #    # => false
  def method_missing(method_symbol, *arguments) # rubocop: disable all
    method_name = method_symbol.to_s

    if method_name =~ /(=|\?)$/
      case $1
      when '='
        attributes[$`] = arguments.first
      when '?'
        !!attributes[$`]
      end
    elsif attributes.include?(method_name)
      return attributes[method_name]
    else
      super
    end
  end

  private

  # Taken from ActiveRecord::AttributeMethods#attribute_for_inspect
  def attribute_for_inspect(value) # rubocop: disable all
    if value.is_a?(String) && value.length > 50
      "#{value[0, 50]}...".inspect
    elsif value.is_a?(Date) || value.is_a?(Time)
      %("#{value.to_s(:db)}")
    elsif value.is_a?(Array) && value.size > 10
      inspected = value.first(10).inspect
      %(#{inspected[0...-1]}, ...])
    else
      value.inspect
    end
  end
end
