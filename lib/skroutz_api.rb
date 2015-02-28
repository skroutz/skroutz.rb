require 'addressable/template'
require 'oauth2'
require 'faraday_middleware'
require 'active_support/all'

require 'skroutz_api/version'
require 'skroutz_api/errors'

module SkroutzApi
  RESOURCES = %w[category sku product shop manufacturer filter_group favorite notification]

  autoload :Client, 'skroutz_api/client'
  autoload :Default, 'skroutz_api/default'
  autoload :Parsing, 'skroutz_api/parsing'
  autoload :Resource, 'skroutz_api/resource'
  autoload :UrlHelpers, 'skroutz_api/url_helpers'
  autoload :CollectionProxy, 'skroutz_api/collection_proxy'
  autoload :PaginatedCollection, 'skroutz_api/paginated_collection'

  RESOURCES.each do |resource|
    autoload resource.capitalize.to_sym, "skroutz_api/#{resource}"

    resource_collection = "#{resource.pluralize}Collection"
    autoload "#{resource_collection.classify}".to_sym,
             "skroutz_api/#{resource_collection.underscore}"
  end

  autoload :Search, 'skroutz_api/search'
end
