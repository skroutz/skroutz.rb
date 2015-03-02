class SkroutzApi::Client
  attr_accessor :client_id, :client_secret, :config

  delegate(*(%w[get post put patch delete head options]), to: :conn)

  def initialize(client_id, client_secret, config = nil)
    @client_id = client_id
    @client_secret = client_secret
    @config = config || SkroutzApi::Default.to_hash
  end

  def oauth_client
    @oauth_client ||= ::OAuth2::Client.
      new(client_id,
          client_secret,
          site: config[:oauth_endpoint],
          authorize_url: config[:authorization_code_endpoint],
          token_url: config[:token_endpoint],
          user_agent: config[:user_agent])
  end

  def token
    @token ||= application_token
  end

  def conn
    @conn ||= Faraday.new(config[:api_endpoint]) do |c|
      c.use ::FaradayMiddleware::FollowRedirects, limit: 5
      c.adapter Faraday.default_adapter
      c.headers = default_headers
    end
  end

  def application_token
    oauth_client.client_credentials.get_token(scope: 'public').token
  end

  def user_token
    raise NotImplementedError
  end

  %w[category sku product shop manufacturer search filter_group
     favorite notification].each do |resource|

    define_method resource.pluralize do
      "SkroutzApi::#{resource.capitalize}".constantize.new self
    end
  end


  private

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
