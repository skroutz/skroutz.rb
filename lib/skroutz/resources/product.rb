# @see http://developer.skroutz.gr/api/v3/product/
class Skroutz::Resources::Product < Skroutz::Resource
  association :sku
  association :shop
  association :category
end
