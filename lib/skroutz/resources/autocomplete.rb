# @see http://developer.skroutz.gr/api/v3/search/#autocomplete
class Skroutz::Resources::Autocomplete < Skroutz::Resource
  alias_attribute :keyword, :k
  alias_attribute :dominant, :d
end
