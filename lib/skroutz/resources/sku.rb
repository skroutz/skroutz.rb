# @see http://developer.skroutz.gr/api/v3/sku/
class Skroutz::Resources::Sku < Skroutz::Resource
  association :category
  association :similar, class_name: 'Sku'
  association :products
  association :reviews
  association :specifications
  association :manufacturer
end
