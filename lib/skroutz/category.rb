# @see http://developer.skroutz.gr/api/v3/category/
class Skroutz::Category < Skroutz::Resource
  association :skus
  association :parent, class_name: 'Category'
  association :children, class_name: 'Category'
  association :manufacturers
end
