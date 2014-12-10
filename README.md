# skroutz-api.rb

Ruby API client for Skroutz /.Alve / Scrooge

## Install

```bash
gem sources -a https://rubygems.skroutz.gr/

gem install skroutz_api --prerelease -v "0.0.1.beta1"
```

## Resources

-  Sku
-  Product
-  Shop
-  Manufacturer
-  FilterGroup
-  Favorite
-  Notification

All resources can be retrieved in 3 ways:

### find
```ruby
  skroutz.some_resource.find some_id
```

### all
```ruby
  skroutz.some_resource.all
```

### page
```ruby
  skroutz.some_resource.page(3, per: 4)
```

Paginated responses respond to `next_page` and `previous_page`.

## Search

Not implemented yet

## Examples

### Categories

```ruby
  skroutz = SkroutzApi::Client.new(client_id, client_secret)

  mobile_phones = skroutz.categories.find 40
  #  => #<OpenStruct id=40,
  #        name="Κινητά Τηλέφωνα",
  #        children_count=0,
  #        image_url="http://a.scdn.gr/images/categories/large/40.jpg",
  #        parent_id=86,
  #        fashion=false,
  #        show_specifications=true,
  #        manufacturer_title="Κατασκευαστές">
```

### SKUs

```ruby
  skroutz = SkroutzApi::Client.new(client_id, client_secret)

  iphone = skroutz.sku.find 390486
  # #<OpenStruct id=390486,
  #    ean="", pn="iPhone 4S 16GB", name="iPhone 4S
  #    (16GB)", display_name="Apple iPhone 4S (16GB)", category_id=40,
  #    first_product_shop_info=nil, click_url=nil, price_max=413.08,
  #    price_min=368.49, reviewscore=4.33333, shop_count=10,
  #    plain_spec_summary="Single SIM, Δίκτυο Σύνδεσης: 3G, Κάμερα: 8 MP,
  #    Οθόνη: 3.5\" , Πυρήνες Επεξεργαστή: 2, RAM: 512 MB,  Εσωτερική Μνήμη
  #    Αποθήκευσης: 16.0 GB,  Λειτουργικό Σύστημα: iOS, SmartPhone",
  #    manufacturer_id=356, future=false, reviews_count=39, virtual=false,
  #    images={"main"=>"http://d.scdn.gr/images/sku_main_images/000390/390486/medium_1234.jpg",
  #    "alternatives"=>["http://a.scdn.gr/images/sku_images/012928/12928351/Untitled.jpg",
  #    "http://b.scdn.gr/images/sku_images/012928/12928352/12345.jpg",
  #    "http://a.scdn.gr/images/sku_images/012928/12928353/smartfon-apple-iphone-4s-16gb-white-md239ru-i-a-30014672b.jpg",
  #    "http://a.scdn.gr/images/sku_images/012928/12928354/smartfon-apple-iphone-4s-16gb-white-md239ru-i-a-30014672b2.jpg",
  #    "http://b.scdn.gr/images/sku_images/012928/12928355/smartfon-apple-iphone-4s-16gb-white-md239ru-i-a-30014672b1.jpg"]}>
```
### Products

```ruby
  skroutz = SkroutzApi::Client.new(client_id, client_secret)

  iphone_product = skroutz.products.find 12661155
  # #<OpenStruct id=12661155, name="APPLE IPHONE 4S 16GB white EU",
  #    sku_id=390486, shop_id=2032, category_id=40, availability="1 έως 3 ημέρες",
  #    click_url="https://www.skroutz.gr/products/show/12661155?client_id=RO6HMDnulVMcaQwxts3xw%3D%3D&from=api",
  #    shop_uid="312", price=368.49>
```


# LICENSE

Copyright (c) 2014 Skroutz S.A

MIT License

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
