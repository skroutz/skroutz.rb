# @see http://developer.skroutz.gr/api/v3/favorites/#list-favorite-lists
class Skroutz::Resources::FavoriteList < Skroutz::Resource
  association :favorites
end
