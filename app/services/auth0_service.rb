require 'net/http'

class Auth0Service

  def initialize auth0Domain = 'https://drew-app.auth0.com/'
    @auth0domain = auth0Domain
  end

  def decode_jwt token
    JWT.decode(token, nil,
      true, # Verify the signature of this token
      algorithm: 'RS256',
      iss: @auth0domain,
      verify_iss: true) do |header|
      public_key_for_jwk_kid(header['kid'])
    end.first
  end

  def public_key_for_jwk_kid kid
    certificate = Rails.cache.fetch "jwk_kid_#{kid}" do
      json_web_key = json_web_keys.find { |key| key['kid'] == kid }

      raise AuthenticationError.new("Cannot find JWK for #{kid}") unless json_web_key.present?

      extract_public_key json_web_key
    end
    OpenSSL::X509::Certificate.new(certificate).public_key
  end

  private

  def json_web_keys
    JSON.parse(Net::HTTP.get URI("#{@auth0domain}.well-known/jwks.json"))['keys']
  end

  def extract_public_key json_web_key
    Base64.decode64(json_web_key['x5c'].first)
  end
end
