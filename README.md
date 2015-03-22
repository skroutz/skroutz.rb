# skroutz.rb

[![Build Status](https://travis-ci.org/skroutz/skroutz.rb.svg?branch=master)](https://travis-ci.org/skroutz/skroutz.rb)
[![Code Climate](https://codeclimate.com/github/skroutz/skroutz.rb/badges/gpa.svg)](https://codeclimate.com/github/skroutz/skroutz.rb)
[![Documentation Status](http://inch-ci.org/github/skroutz/skroutz.rb.svg?branch=master)](http://inch-ci.org/github/skroutz/skroutz.rb)

Ruby API client for Skroutz / Alve / Scrooge

## Install

```bash
gem install skroutz_api
```

## Resources

- Category
- Sku
- Product
- Shop
- Manufacturer
- FilterGroup
- Favorite
- Notification

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

  #<SkroutzApi::Category id: 40, name: Κινητά Τηλέφωνα, children_count: 0,
    image_url: http://a.scdn.gr/images/categories/large/40.jpg, parent_id: 86,
    fashion: false, path: 76,1269,2,86,40, show_specifications: true,
    manufacturer_title: Κατασκευαστές>
```

### SKUs

```ruby
  skroutz = SkroutzApi::Client.new(client_id, client_secret)

  iphone = skroutz.sku.find 390486

  #<SkroutzApi::Sku id: 390486, ean: , pn: iPhone 4S 16GB, name: iPhone 4S
    (16GB), display_name: Apple iPhone 4S (16GB), category_id: 40,
    first_product_shop_info: 1521|Kaizer Shop|kaizershop, click_url: ,
    price_max: 310.0, price_min: 310.0, reviewscore: 4.43284, shop_count: 1,
    plain_spec_summary: SmartPhone,  Single SIM, Οθόνη: 3.5" , CPU: 1000
    MHz, Πυρήνες CPU: 2, RAM: 512 MB,  Μνήμη Αποθήκευσης: 16.0 GB,  Κάμερα:
    8 MP,  Δίκτυο Σύνδεσης: 3G, Λειτουργικό Σύστημα: iOS, manufacturer_id:
    356, future: false, reviews_count: 67, virtual: false, images:
    {"main"=>"http://d.scdn.gr/images/sku_main_images/000390/390486/medium_1234.jpg",
    "alternatives"=>["http://a.scdn.gr/images/sku_images/012928/12928351/Untitled.jpg",
    "http://b.scdn.gr/images/sku_images/012928/12928352/12345.jpg",
    "http://a.scdn.gr/images/sku_images/012928/12928353/smartfon-apple-iphone-4s-16gb-white-md239ru-i-a-30014672b.jpg",
    "http://a.scdn.gr/images/sku_images/012928/12928354/smartfon-apple-iphone-4s-16gb-white-md239ru-i-a-30014672b2.jpg",
    "http://b.scdn.gr/images/sku_images/012928/12928355/smartfon-apple-iphone-4s-16gb-white-md239ru-i-a-30014672b1.jpg"]}>
```

### Products

```ruby
  skroutz = SkroutzApi::Client.new(client_id, client_secret)

  iphone_product = skroutz.products.find 12661155

  #<SkroutzApi::Product id: 12661155, name: APPLE IPHONE 4S 16GB white EU, sku_id: 390486,
    shop_id: 2032, category_id: 40, availability: Σε απόθεμα,
    click_url: https://www.skroutz.gr/products/show/12661155?client_id=a49yR0rl6TrVjBmJ8DF3sg%3D%3D&from=api,
    shop_uid: 312, price: 364.49>
```


# LICENSE

Copyright (c) 2015 Skroutz S.A

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
