module Skroutz::Resources
  RESOURCES = %w[category sku product shop manufacturer filter_group autocomplete
    location address specification review favorite_list favorite notification].freeze

  RESOURCES.each do |resource|
    autoload resource.classify.to_sym, "skroutz/resources/#{resource}"

    resource_collection = "#{resource.pluralize}_collection"
    autoload "#{resource_collection.classify}".to_sym,
             "skroutz/resources/#{resource_collection.underscore}"
  end

  module_function

  def to_a
    RESOURCES
  end
end
