# skroutz.rb

[![Build Status](https://travis-ci.org/skroutz/skroutz.rb.svg?branch=master)](https://travis-ci.org/skroutz/skroutz.rb)
[![Code Climate](https://codeclimate.com/github/skroutz/skroutz.rb/badges/gpa.svg)](https://codeclimate.com/github/skroutz/skroutz.rb)
[![Coverage Status](https://coveralls.io/repos/skroutz/skroutz.rb/badge.svg)](https://coveralls.io/r/skroutz/skroutz.rb)
[![Documentation Status](http://inch-ci.org/github/skroutz/skroutz.rb.svg?branch=master)](http://inch-ci.org/github/skroutz/skroutz.rb)

Ruby API client for [Skroutz](https://skroutz.gr) / [Alve](https://alve.com) / [Scrooge](https://scrooge.co.uk)

## Installation

```bash
gem install skroutz
```

Or add it to your Gemfile

```ruby
gem 'skroutz'
```

## Resources

- [Category](http://developer.skroutz.gr/api/v3/category/)
- [Sku](http://developer.skroutz.gr/api/v3/sku/)
- [Product](http://developer.skroutz.gr/api/v3/product/)
- [Shop](http://developer.skroutz.gr/api/v3/shop/)
- [Manufacturer](http://developer.skroutz.gr/api/v3/manufacturer/)
- [FilterGroup](http://developer.skroutz.gr/api/v3/filter_groups/)
- [Favorite](http://developer.skroutz.gr/api/v3/favorites/)
- [Notification](http://developer.skroutz.gr/api/v3/notifications/)

## Creating a client

```ruby
  skroutz = Skroutz::Client.new('client_id', 'client_secret')
```

## Search

```ruby
  skroutz.search('iphone')

  # => [#<Skroutz::Category id: 40, name: "Κινητά Τηλέφωνα", children_count: 0,
  # image_url: "http://a.scdn.gr/images/categories/large/40.jpg", parent_id:
  # 86, fashion: false, path: "76,1269,2,86,40", show_specifications: true,
  # manufacturer_title: "Κατασκευαστές", match_count: 18>,
  #  #<Skroutz::Category id: 583, name: "Ανταλλακτικά Κινητών τηλεφώνων",
  # children_count: 0, image_url: "http://a.scdn.gr/images/categories/large/583.jpg", parent_id: 86,
  # fashion: false, path: "76,1269,2,86,583", show_specifications: false,
  # manufacturer_title: "Κατασκευαστές", match_count: 4062>
  # ...
```


## Examples

### Categories

```ruby
  skroutz = Skroutz::Client.new('client_id', 'client_secret')

  mobile_phones = skroutz.categories.find 40

  # => #<Skroutz::Category id: 40, name: "Κινητά Τηλέφωνα", children_count: 0,
  # image_url: "http://a.scdn.gr/images/categories/large/40.jpg", parent_id:
  # 86, fashion: false, path: "76,1269,2,86,40", show_specifications: true,
  # manufacturer_title: "Κατασκευαστές">

  # Get all categories, paginated
  skroutz.categories.all
  # => [#<Skroutz::Category id: 1, name: "Σταθερή Τηλεφωνία", children_count: 5, 
  # image_url: "http://a.scdn.gr/images/categories/large/1.jpg", parent_id: 2, 
  # fashion: false, path: "76,1269,2,1", show_specifications: false, 
  # manufacturer_title: "Κατασκευαστές">,
  #  #<Skroutz::Category id: 2, name: "Τηλεφωνία", children_count: 3,
  # image_url: "http://d.scdn.gr/images/categories/large/201501271...",
  # parent_id: 1269, fashion: false, path: "76,1269,2", show_specifications:
  # false, manufacturer_title: "Κατασκευαστές">,
  #  #<Skroutz::Category id: 5, name: "Φωτογραφία & Video", children_count:
  # 3, image_url: "http://a.scdn.gr/images/categories/large/5.jpg",
  # parent_id: 1269, fashion: false, path: "76,1269,5", show_specifications:
  # false, manufacturer_title: "Κατασκευαστές">,
  #  #<Skroutz::Category id: 6, name: "Διάφορα Εικόνας", children_count: 2,
  # image_url: "http://c.scdn.gr/images/categories/large/201501271...",
  # parent_id: 309, fashion: false, path: "76,1269,309,6",
  # show_specifications: false, manufacturer_title: "Κατασκευαστές">,
  # ...

  # Get the SKUs of a Category without intermediate requests
  skroutz.categories(40).skus
  # => [#<Skroutz::Sku id: 2119391, ean: "", pn: "GT-E1200", name: "E1200",
  # display_name: "Samsung E1200", category_id: 40, first_product_shop_info:
  # nil, click_url: nil, price_max: 42.0, price_min: 12.61, reviewscore:
  # 4.39286, shop_count: 20, plain_spec_summary: "Feature Phone,  Single
  # SIM, Οθόνη: 1.52\" ,   Μνήμη...", manufacturer_id: 28, future: false,
  # reviews_count: 28, virtual: false, images:
  # {"main"=>"http://d.scdn.gr/images/sku_main_images/002119/2119391/medium_gr_GT-E1200ZWMVGR_301_Front",
  # "alternatives"=>["http://a.scdn.gr/images/sku_images/012918/12918567/gr_GT-E1200ZWMVGR_309_Dynamic",
  # "http://b.scdn.gr/images/sku_images/012918/12918568/gr_GT-E1200ZWMVGR_304_Left",
  # "http://a.scdn.gr/images/sku_images/012918/12918573/gr_GT-E1200ZWMVGR_323_Right",
  # "http://c.scdn.gr/images/sku_images/012918/12918574/gr_GT-E1200ZWMVGR_322_Back"]}>,
  #  #<Skroutz::Sku id: 3599366, ean: ...
 

```

### SKUs

```ruby
  skroutz = Skroutz::Client.new('client_id', 'client_secret')

  iphone = skroutz.skus.find 390486

  # => #<Skroutz::Sku id: 390486, ean: "", pn: "iPhone 4S 16GB", name: "iPhone
  # 4S (16GB)", display_name: "Apple iPhone 4S (16GB)", category_id: 40,
  # first_product_shop_info: "1521|Kaizer Shop|kaizershop", click_url: nil,
  # price_max: 310.0, price_min: 310.0, reviewscore: 4.43284, shop_count: 1,
  # plain_spec_summary: "SmartPhone,  Single SIM, Οθόνη: 3.5\" , CPU: 1000
  # M...", manufacturer_id: 356, future: false, reviews_count: 67, virtual:
  # false, images:
  # {"main"=>"http://d.scdn.gr/images/sku_main_images/000390/390486/medium_1234.jpg",
  # "alternatives"=>["http://a.scdn.gr/images/sku_images/012928/12928351/Untitled.jpg",
  # "http://b.scdn.gr/images/sku_images/012928/12928352/12345.jpg",
  # "http://a.scdn.gr/images/sku_images/012928/12928353/smartfon-apple-iphone-4s-16gb-white-md239ru-i-a-30014672b.jpg",
  # "http://a.scdn.gr/images/sku_images/012928/12928354/smartfon-apple-iphone-4s-16gb-white-md239ru-i-a-30014672b2.jpg",
  # "http://b.scdn.gr/images/sku_images/012928/12928355/smartfon-apple-iphone-4s-16gb-white-md239ru-i-a-30014672b1.jpg"]}>
```

### Products

```ruby
  skroutz = Skroutz::Client.new('client_id', 'client_secret')

  iphone_product = skroutz.products.find 12661155

  # => #<Skroutz::Product id: 12661155, name: "APPLE IPHONE 4S 16GB white EU",
  # sku_id: 390486, shop_id: 2032, category_id: 40, availability: "Σε απόθεμα", 
  # click_url: "https://www.skroutz.gr/products/show/12661155?clie...", shop_uid: "312", 
  # price: 364.49>

```

In this manner you may retrieve most [resources](#resources).

## Pagination

For paginated responses, the following methods will be available:

* first_page?
* last_page?
* first
* last
* next
* previous

## Configuration

The following configuration options are available upon client initialization:

### logger

Which logger to use.  
**Default**: No logging is performed.

Example: 

```ruby
# Log to STDOUT
client = Skroutz::Client.new('client_id', 'client_secret', logger: Logger.new(STDOUT)) 
```

### timeout

How much time (__in seconds__) to wait for a server response.  
**Default**: 5 seconds

### adapter

Which HTTP adapter to use to perform the API requests.  
**Default**: `Net::HTTP`  
> Note: You can only pick a [faraday](https://github.com/lostisland/faraday) compatible adapter.  
Make sure you have the gem of the selected adapter installed.

### user_agent

The user agent string to use for the API requests.  
**Default**: `skroutz.rb`

### api_endpoint

The root URI of the targeted API.  
**Default**: `https://api.skroutz.gr`

### oauth_endpoint

The endpoint from which to authorize via OAuth2.0.  
**Default**: `https://skroutz.gr`

### authorization_code_endpoint

The endpoint from which to acquire OAuth2.0 [authorization code](https://tools.ietf.org/html/rfc6749#section-4.1).  
**Default**: `/oauth2/authorizations/new`

### token_endpoint

The [endpoint](https://tools.ietf.org/html/rfc6749#section-3.2) from which to acquire OAuth2.0 access token.  
**Default**: `/oauth2/token`

### media type

The value of the HTTP `Accept` header to specify the desired [media type](http://tools.ietf.org/html/rfc2046).  
**Default**: `application/vnd.skroutz+json; version=3`

### application_permissions

The set of [permissions](http://developer.skroutz.gr/authorization/permissions/) to be obtained.  
**Default**: `['public']

## Compatibility

The following Ruby implementations are supported:

* MRI 1.9.3
* MRI 2.1.0
* MRI 2.2.0

It may inadvertently work (or seem to work) on other Ruby implementations, 
however support will only be provided for the versions listed above.

## Development

Please take some time to read our [contribution guide](CONTRIBUTING.md) first.

### Running the tests

Run all the tests:
```bash
bundle exec rake
```

Run them continuously with guard:
```bash
bundle exec guard
```

Fix any rubocop offences:
```bash
bundle exec rubocop
```

# LICENSE

Copyright (c) 2015 Skroutz S.A, MIT Licence. 
See [LICENSE.txt](https://github.com/skroutz/skroutz.rb/blob/master/LICENSE.txt) for further details.
