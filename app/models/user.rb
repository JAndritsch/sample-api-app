class User < ActiveRecord::Base
  attr_accessor :password_confirmation

  validates :username, uniqueness: true, presence: true
  validates :password, presence: true
  validates :auth_token, uniqueness: true, allow_nil: true
  validates :salt, uniqueness: true, allow_nil: true
  validate  :passwords_match, if: :password_changed?

  before_create :encrypt_password!

  def generate_auth_token!
    begin
      self.auth_token = SecureRandom.hex
    end while self.class.exists?(auth_token: auth_token)
    save
  end

  def remove_auth_token!
    update_attribute(:auth_token, nil)
  end

  private

  def passwords_match
    unless password == password_confirmation
      errors[:password_confirmation] << "Does not match the supplied password"
    end
  end

  def password_changed?
    changes.include?(:password)
  end

  def generate_salt!
    begin
      self.salt = SecureRandom.hex
    end while self.class.exists?(salt: salt)
  end

  def encrypt_password!
    generate_salt! unless salt.present?
    authenticator = UserAuthenticator.new(self)
    self.password = authenticator.encrypted_password(password)
  end

end
