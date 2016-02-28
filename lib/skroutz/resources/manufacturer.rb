# @see http://developer.skroutz.gr/api/v3/manufacturer/
class Skroutz::Resources::Manufacturer < Skroutz::Resource
  association :categories
  association :skus
end
