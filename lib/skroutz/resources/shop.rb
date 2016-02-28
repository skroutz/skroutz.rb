# @see http://developer.skroutz.gr/api/v3/shop/
class Skroutz::Resources::Shop < Skroutz::Resource
  association :products
  association :locations
  association :reviews
end
