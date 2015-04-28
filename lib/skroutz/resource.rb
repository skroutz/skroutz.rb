class Skroutz::Resource
  include Skroutz::Associations

  attr_accessor :attributes, :client

  alias :to_hash :attributes

  def initialize(attributes, client)
    @attributes = attributes
    @client = client
  end

  def resource
    @resource ||= self.class.to_s.demodulize.tableize.singularize
  end

  def resource_prefix
    @resource_prefix ||= resource.pluralize
  end

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
