require 'addressable/template'
require 'oauth2'
require 'faraday_middleware'
require 'active_support/all'

require 'skroutz/version'
require 'skroutz/errors'
require 'skroutz/inflections'

module Skroutz
  RESOURCES = %w[category sku product shop manufacturer filter_group autocomplete
                 location specification favorite notification]

  autoload :Client, 'skroutz/client'
  autoload :Default, 'skroutz/default'
  autoload :Parsing, 'skroutz/parsing'
  autoload :Resource, 'skroutz/resource'
  autoload :UrlHelpers, 'skroutz/url_helpers'
  autoload :CollectionProxy, 'skroutz/collection_proxy'
  autoload :PaginatedCollection, 'skroutz/paginated_collection'

  RESOURCES.each do |resource|
    autoload resource.capitalize.to_sym, "skroutz/#{resource}"

    resource_collection = "#{resource.pluralize}Collection"
    autoload "#{resource_collection.classify}".to_sym,
             "skroutz/#{resource_collection.underscore}"
  end

  autoload :Search, 'skroutz/search'
end
