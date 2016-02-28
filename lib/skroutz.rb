require 'oauth2'
require 'faraday_middleware'
require 'active_support/all'

require 'skroutz/version'
require 'skroutz/errors'
require 'skroutz/inflections'
require 'skroutz/resources'

module Skroutz
  autoload :Client, 'skroutz/client'
  autoload :Default, 'skroutz/default'
  autoload :Parsing, 'skroutz/parsing'
  autoload :Resource, 'skroutz/resource'
  autoload :Associations, 'skroutz/associations'
  autoload :UrlHelpers, 'skroutz/url_helpers'
  autoload :CollectionProxy, 'skroutz/collection_proxy'
  autoload :PaginatedCollection, 'skroutz/paginated_collection'
end
