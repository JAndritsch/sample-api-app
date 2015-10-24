class ApplicationController < ActionController::API
  include ActionController::Serialization

  protected

  def authenticate!
    lookup_user do |user|
      head :unauthorized unless user
    end
  end

  def lookup_user
    authenticate_or_request_with_http_token do |token, options|
      user = User.find_by(auth_token: token)
      yield user
    end
  end
end
