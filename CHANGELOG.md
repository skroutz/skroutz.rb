# Change Log
All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## [0.2.0] - 2016-01-04

### Added

* Skroutz::Client#token= for setting a pre-obtained OAuth2.0 access token

## [0.1.2] - 2015-04-28

### Added

* Favorite <- Sku assoiciation
* FavoriteList <- Favorite association
* JSON serialization capability of Skroutz::Resource
* reload! method for code reloading in development

### Fixed

* Skroutz::Resource#resource handling for multiple word resources (eg.  FavoriteList)

## [0.1.1] - 2015-03-29

### Removed

* addressable gem dependency

## [0.1.0] - 2015-03-29

### Added

* Associations. [Read More](https://github.com/skroutz/skroutz.rb#associations)
* Favorite Lists. User favorite lists can be fetched  
  Example:
  ```ruby
  client = Skroutz::Client.new('', '')
  client.user_token = 'a valid user token'
  client.favorite_lists.all
  ```
* Skroutz::Client#user_token and Skroutz::Client#user_token=
* Reviews. The reviews of a SKU can be fetched  
  Example:
  ```ruby
  client.skus(42).reviews
  ```
* Specifications. The specifications of a SKU can be fetched  
  Example:
  ```ruby
  client.skus(42).specifications
  ```
* Locations. The locations of a Shop can be fetched  
  Example: 
  ```ruby
  client.shops(42).locations # GET /shops/42/locations
  ```
* Rate-limiting error handling, when a request fails due to
  rate-limiting, `Skroutz::RateLimitingError` is raised
* For all methods which perform a request, the HTTP verb can be
  specified using either the `:verb`, or `:via` options  
  Example: 
  ```ruby
  client.categories.all(via: :post) # POST /categories
  ```
* Direct association requests. Intermediate requests for nested
  resources can be avoided  
  Example: 
  ```ruby
  client.categories(42).skus # Performs 1 request to /categories/42/sks
  ```
* `Skroutz::Client#autocomplete`
* AR-like resource inspection using `Skroutz::Resource#inspect`
* All collections respond to `#meta` with contains response metadata

### Changed

* Direct instantiation of abstract class `Skroutz::CollectionProxy` raises `RuntimeError`
* Responses with status 401 Unauthorized raise `Skroutz::UnauthorizedError`
* Responses with status 400 Bad Request raise `Skroutz::ClientError`
* Resource attribute predicate methods always return boolean values
  Example:
  ```ruby
  client.skus.find(42).virtual? # => false
  ```
* The name of the gem to `skroutz` from `skroutz_api` and the namespace to `Skroutz` from `SkroutzApi` accordingly
* `Skroutz::PaginatedCollection#is_at_last_page?` is renamed to `#last_page?`
* `Skroutz::PaginatedCollection#is_at_first_page?` is renamed to `#first_page?`
* Trying to fetch a non-existant page returns nil instead of empty Array
* Pagination methods depend only on link headers
* Resources and collections are automatically inferred at parsing based
  on the root key of the JSON response

### Fixed
* Properly handle requests and parsing of two_word resources (eg. filter_groups)
* Make `Skroutz::Client#search` work

## [0.0.4] - 2015-03-22
### Changed

* Make response timeout configurable (in seconds)
* Make HTTP adapter configurable
* Make response logger configurable

### Fixed

* Memoization in SkroutzApi::Resource#resource now works as expected
