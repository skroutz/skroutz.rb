class SkroutzApi::Default
  API_ENDPOINT                = 'https://api.skroutz.gr'
  MEDIA_TYPE                  = 'application/vnd.skroutz+json; version=3'
  USER_AGENT                  = 'skroutz.rb'
  OAUTH_ENDPOINT              = 'http://skroutz.gr'
  AUTHORIZATION_CODE_ENDPOINT = '/oauth2/authorizations/new'
  TOKEN_ENDPOINT              = '/oauth2/token'
  PAGINATION_PAGE_SIZE        = 25

  class << self
    def to_hash
      constants.reduce({}) { |h, const| h[const.downcase] = const_get const; h }
    end
  end
end
