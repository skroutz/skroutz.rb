# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'skroutz_api/version'

Gem::Specification.new do |spec|
  spec.name          = "skroutz_api"
  spec.version       = SkroutzApi::VERSION
  spec.authors       = ["Dimitris Zorbas"]
  spec.email         = ["zorbash@skroutz.gr"]
  spec.summary       = %q{Skroutz API client}
  spec.description   = %q{Ruby API client for Skroutz}
  spec.homepage      = "https://github.com/skroutz/skroutz.rb"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'rspec', '~> 3.2'

  spec.add_dependency 'addressable', '~> 2.3'
  spec.add_dependency 'oauth2', '~> 1.0'
  spec.add_dependency 'faraday_middleware', '~> 0.9'
  spec.add_dependency 'activesupport'
end
