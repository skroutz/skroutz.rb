class Skroutz::Shop < Skroutz::Resource
  def products
    Skroutz::ProductsCollection.new(client, self)
  end
end
