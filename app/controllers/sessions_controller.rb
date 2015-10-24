class SessionsController < ApplicationController

  before_filter :authenticate!, only: [:destroy]

  def create
    user = User.find_by(username: params[:username])
    authenticator = UserAuthenticator.new(user)
    if authenticator.valid_password?(params[:password])
      user.generate_auth_token!
      render json: { auth_token: user.auth_token }, status: :created
    else
      head :unauthorized
    end
  end

  def destroy
    lookup_user do |user|
      user.remove_auth_token!
    end
    head :ok
  end

end
