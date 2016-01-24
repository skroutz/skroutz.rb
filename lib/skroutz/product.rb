# @see http://developer.skroutz.gr/api/v3/product/
class Skroutz::Product < Skroutz::Resource
  association :sku
  association :shop
  association :category
end
