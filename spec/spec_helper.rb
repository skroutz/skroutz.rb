require 'skroutz_api'

require 'webmock/rspec'

Dir['./spec/support/**/*.rb'].sort.each(&method(:require))

WebMock.disable_net_connect!

RSpec.configure do |config|
  # Formatting
  config.formatter = :documentation
  config.color = true

  # Filtering
  config.filter_run :focus
  config.run_all_when_everything_filtered = true

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = :random

  # Seed global randomization in this process using the `--seed` CLI option.
  # Setting this allows you to use `--seed` to deterministically reproduce
  # test failures related to randomization by passing the same `--seed` value
  # as the one that triggered the failure.
  Kernel.srand config.seed

  config.expect_with :rspec do |expectations|
    # Enable only the newer, non-monkey-patching expect syntax.
    # For more details, see:
    #   - http://myronmars.to/n/dev-blog/2012/06/rspecs-new-expectation-syntax
    expectations.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    # Enable only the newer, non-monkey-patching expect syntax.
    # For more details, see:
    #   - http://teaisaweso.me/blog/2013/05/27/rspecs-new-message-expectation-syntax/
    mocks.syntax = :expect

    # Prevents you from mocking or stubbing a method that does not exist on
    # a real object. This is generally recommended.
    mocks.verify_partial_doubles = false
  end
end

[:get, :head, :patch, :post, :put, :delete].each do |verb|
  Object.send :define_method, "stub_#{verb}" do |path|
    stub_api_call(verb, path)
  end
end

def stub_api_call(verb, path)
  stub_request(verb, "#{SkroutzApi::Default.to_hash[:api_endpoint]}/#{path}")
end

def fixture_path
  File.expand_path('../fixtures', __FILE__)
end

def fixture(key)
  @fixtures_memo ||= {}
  @fixtures_memo[key] ||= begin
    YAML.load_file(File.join(fixture_path, "#{key}.yml"))
  end
end

def stub_with_fixture(verb, path, key)
  send("stub_#{verb}", path).to_return(headers: fixture(key)[:headers],
                                       body: fixture(key)[:body])
end
