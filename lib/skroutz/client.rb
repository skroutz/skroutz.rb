class Skroutz::Client
  include Skroutz::Parsing

  attr_writer :token
  attr_accessor :client_id, :client_secret, :config, :user_token

  # Respond to HTTP methods
  delegate(*Faraday::Connection::METHODS, to: :conn)

  def initialize(client_id, client_secret, config = {})
    @client_id = client_id
    @client_secret = client_secret
    @config = Skroutz::Default.to_hash(flavor: config[:flavor]).merge config
  end

  # Returns the token used for OAuth2.0 authorization
  #
  # Automatically acquires an application token (client credentials)
  # unless a user_token is provided using {#user_token=}
  # @see http://developer.skroutz.gr/authorization/
  # @return [String] The access_token
  def token
    @token ||= user_token || application_token
  end

  # Returns a connection to directly perform requests
  def conn
    @conn ||= Faraday.new(config[:api_endpoint]) { |client| configure_client(client) }
  end

  # Obtains an application token and returns it
  # @see http://developer.skroutz.gr/authorization/flows/#application-token
  #
  # @return [String] The application access_token
  def application_token
    oauth_client.
      client_credentials.
      get_token(scope: config[:application_permissions].join(' ')).
      token
  end

  Skroutz::RESOURCES.each do |resource|
    # @example
    # def categories
    #   Skroutz::CategoriesCollection.new id, self
    # end
    define_method resource.pluralize do |id = nil|
      "Skroutz::#{resource.classify.pluralize}Collection".constantize.new id, self
    end
  end

  # Performs search
  #
  # @param [String] q The search query
  # @param [Hash] options request options
  # @return {Skroutz::PaginatedCollection}
  def search(q, options = {})
    response = get 'search', { q: q }.merge(options)

    return parse(response) unless block_given?

    yield response
  end

  # Performs autocomplete search
  #
  # @param [String] q The autocomplete search query
  # @param [Hash] options request options
  # @return {Skroutz::PaginatedCollection}
  def autocomplete(q, options = {})
    response = get 'autocomplete', { q: q }.merge(options)

    return parse(response) unless block_given?

    yield response
  end

  # Identity method
  # @returns self
  def client
    self
  end

  private

  def oauth_client
    @oauth_client ||= begin
      ::OAuth2::Client.new(client_id,
                           client_secret,
                           site: config[:oauth_endpoint],
                           authorize_url: config[:authorization_code_endpoint],
                           token_url: config[:token_endpoint],
                           user_agent: config[:user_agent])
    end
  end

  def configure_client(client)
    client.use ::FaradayMiddleware::FollowRedirects, limit: 5
    client.use ::Skroutz::ErrorHandler
    client.use Skroutz::TimeoutHandler
    client.use Faraday::Response::Logger, @config[:logger] if @config[:logger]

    client.adapter @config[:adapter] || Faraday.default_adapter
    client.headers = default_headers
    client.options.timeout = @config[:timeout]
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
