class UserAuthenticator

  attr_reader :user

  def initialize(user)
    @user = user
  end

  def valid_password?(password)
    return false unless user
    user.password == encrypted_password(password)
  end

  def encrypted_password(password)
    Digest::MD5.hexdigest(password + user.salt)
  end
end
