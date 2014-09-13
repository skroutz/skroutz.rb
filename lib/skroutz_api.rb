require 'addressable/template'
require 'oauth2'
require 'faraday_middleware'

require 'skroutz_api/version'

module SkroutzApi
  autoload :Client, 'skroutz_api/client'
  autoload :Default, 'skroutz_api/default'
  autoload :Parsing, 'skroutz_api/parsing'
  autoload :Resource, 'skroutz_api/resource'
  autoload :Category, 'skroutz_api/category'
  autoload :Sku, 'skroutz_api/sku'
  autoload :Product, 'skroutz_api/product'
  autoload :Shop, 'skroutz_api/shop'
  autoload :Manufacturer, 'skroutz_api/manufacturer'
  autoload :Search, 'skroutz_api/search'
  autoload :FilterGroup, 'skroutz_api/filter_group'
  autoload :Favorite, 'skroutz_api/favorite'
  autoload :Notification, 'skroutz_api/notification'
  autoload :PaginatedCollection, 'skroutz_api/paginated_collection'
end
