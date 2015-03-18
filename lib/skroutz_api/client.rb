class SkroutzApi::Client
  include SkroutzApi::Parsing

  attr_accessor :client_id, :client_secret, :config

  delegate(*Faraday::Connection::METHODS, to: :conn)

  def initialize(client_id, client_secret, config = {})
    @client_id = client_id
    @client_secret = client_secret
    @config = SkroutzApi::Default.to_hash.merge config
  end

  def token
    @token ||= application_token
  end

  def conn
    @conn ||= Faraday.new(config[:api_endpoint]) do |c|
      c.use ::FaradayMiddleware::FollowRedirects, limit: 5
      c.use ::SkroutzApi::ErrorHandler
      c.use SkroutzApi::TimeoutHandler
      c.use Faraday::Response::Logger, @config[:logger] if @config[:logger]

      c.adapter @config[:adapter] || Faraday.default_adapter
      c.headers = default_headers
      c.options.timeout = @config[:timeout]
    end
  end

  def application_token
    oauth_client.
      client_credentials.
      get_token(scope: config[:application_permissions].join(' ')).
      token
  end

  def user_token
    raise NotImplementedError
  end

  SkroutzApi::RESOURCES.each do |resource|
    define_method resource.pluralize do
      "SkroutzApi::#{resource.classify.pluralize}Collection".constantize.new self
    end
  end

  def search(q, options = {})
    response = get 'search', { q: q }.merge(options)

    return parse(response) unless block_given?

    yield response
  end

  def client
    self
  end

  private

  def oauth_client
    @oauth_client ||= ::OAuth2::Client.
      new(client_id,
          client_secret,
          site: config[:oauth_endpoint],
          authorize_url: config[:authorization_code_endpoint],
          token_url: config[:token_endpoint],
          user_agent: config[:user_agent])
  end

  def default_headers
    {
      user_agent: config[:user_agent],
      accept: config[:media_type]
    }.merge authorization_header
  end

  def authorization_header
    { authorization: "Bearer #{token}" }
  end
end
