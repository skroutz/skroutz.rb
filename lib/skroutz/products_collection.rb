class Skroutz::ProductsCollection < Skroutz::CollectionProxy
  def search_by_shop_uid(shop_uid)
    response = client.get("#{base_path}/search", shop_uid: shop_uid)

    return parse(response) unless block_given?

    yield response
  end
end
