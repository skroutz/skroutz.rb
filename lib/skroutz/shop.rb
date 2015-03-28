class Skroutz::Shop < Skroutz::Resource
  association :products
  association :locations
  association :reviews
end
