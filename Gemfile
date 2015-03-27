source 'https://rubygems.org'

# Specify your gem's dependencies in skroutz-api-rb.gemspec
gemspec

group :development do
  gem 'awesome_print', require: 'ap'
  gem 'pry-debugger', platforms: :mri_19
  gem 'pry-byebug', platforms: :mri_21
  gem 'pry-doc'

  gem 'guard-rubocop', require: false
  gem 'rubocop', '~> 0.29.0'
end

group :test do
  gem 'guard-rspec', require: false
  gem 'coveralls', require: false
  gem 'webmock', '>= 1.9'
end
