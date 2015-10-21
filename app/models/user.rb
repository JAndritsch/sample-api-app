class User < ActiveRecord::Base
  attr_accessor :password_confirmation

  validates :username, uniqueness: true, presence: true
  validates :password, presence: true
  validate  :passwords_match, if: :password_changed?

  private

  def passwords_match
    unless password == password_confirmation
      errors[:password_confirmation] << "Does not match the supplied password"
    end
  end

  def password_changed?
    changes.include?(:password)
  end

end
