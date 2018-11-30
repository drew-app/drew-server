class ApplicationController < ActionController::API
  before_action :authenticate

  def authenticate
    raise AuthenticationError.new('No token') unless request.headers['Authorization']

    jwt_token.present?
  end

  def current_user
    User.find_by!(email: jwt_token['email'])
  end

  private

  def jwt_token
    token = request.headers['Authorization'].split(' ').last
    jwt = Auth0Service.new.decode_jwt(token)

    User.create(email: jwt['email'], nickname: jwt['nickname'], avatar_url: jwt['picture'], token_details: jwt) unless User.exists?(email: jwt['email'])
    jwt
  end
end
