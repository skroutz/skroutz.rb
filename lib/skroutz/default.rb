# Contains client defaults
class Skroutz::Default
  USER_AGENT                  = 'skroutz.rb'
  AUTHORIZATION_CODE_ENDPOINT = '/oauth2/authorizations/new'
  TOKEN_ENDPOINT              = '/oauth2/token'
  PAGINATION_PAGE_SIZE        = 25
  APPLICATION_PERMISSIONS     = %w[public]
  REQUEST_TIMEOUT             = 5 # seconds

  class << self
    def to_hash(flavor: nil)
      flavor ||= default_flavor

      raise ArgumentError, "Missing flavor: #{flavor}" unless flavors.include? flavor

      constants.reduce(flavor_defaults[flavor]) do |h, const|
        h[const.downcase] = const_get(const)
        h
      end
    end

    private

    def flavors
      [:skroutz, :alve, :scrooge]
    end

    def default_flavor
      :skroutz
    end

    def flavor_defaults
      {
        skroutz: {
          api_endpoint: 'https://api.skroutz.gr',
          media_type: 'application/vnd.skroutz+json; version=3',
          oauth_endpoint: 'http://skroutz.gr'
        },
        alve: {
          api_endpoint: 'https://api.alve.com',
          media_type: 'application/vnd.alve+json; version=3',
          oauth_endpoint: 'http://alve.com'
        },
        scrooge: {
          api_endpoint: 'https://api.scrooge.co.uk',
          media_type: 'application/vnd.scrooge+json; version=3',
          oauth_endpoint: 'http://scrooge.co.uk'
        }
      }
    end
  end
end
