class SkroutzApi::Shop < SkroutzApi::Resource
  def products
    SkroutzApi::ProductsCollection.new(client, self)
  end
end
