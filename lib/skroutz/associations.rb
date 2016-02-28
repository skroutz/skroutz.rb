module Skroutz::Associations
  include Skroutz::UrlHelpers
  extend ActiveSupport::Concern

  class_methods do
    def association(name, options = {})
      associations << name
      define_association(name, options)
    end

    def associations
      @associations ||= []
    end

    private

    def define_association(name, options) # rubocop:disable Metrics/AbcSize
      define_method(name) do
        class_name = options.fetch(:class_name, name.to_s).classify.pluralize
        owner = attributes.key?("#{name}_id") ? nil : self
        prefix = options[:class_name] && owner ? name.to_s : nil

        klass = "Skroutz::Resources::#{class_name}Collection".constantize
        collection = klass.new nil, client, owner, prefix: prefix

        owner ? collection : collection.find(attributes["#{name}_id"])
      end
    end
  end
end
