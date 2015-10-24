class ApplicationController < ActionController::API
  include ActionController::Serialization

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  protected

  def authenticate!
    head :unauthorized unless auth_token
    lookup_user do |user|
      head :unauthorized unless user
    end
  end

  def lookup_user
    user = User.find_by(auth_token: auth_token)
    yield user
  end

  def auth_token
    auth = request.headers['Authorization']
    if auth.present?
      match = auth.match(/Token token=(\w+)/)
      if match
        match[1]
      end
    end
  end

  def record_not_found
    head :not_found
  end

end
