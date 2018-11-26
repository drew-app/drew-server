module Test
  module ControllerHelpers
    def sign_in_user user, token = 'SOMETOKEN'
      return unless user
      request.headers['Authorization'] = token
      allow(controller).to receive(:jwt_token).and_return({
        'nickname' => user.nickname,
        'email' => user.email,
        'picture' => user.avatar_url
      })
    end
  end
end