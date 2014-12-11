class SkroutzApi::ProductsCollection < SkroutzApi::CollectionProxy
  def search_by_shop_uid(shop_uid)
    response = client.get("#{base_path}/search", shop_uid: shop_uid)

    return SkroutzApi::PaginatedCollection.new(self, response) unless block_given?

    yield response
  end
end
