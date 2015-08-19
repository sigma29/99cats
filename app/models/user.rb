require 'bcrypt'

class User < ActiveRecord::Base
  attr_reader :password

  validates :user_name, :password_digest, :session_token, presence: true
  validates :user_name, :session_token, uniqueness: true
  validates :password, length: { minimum: 8 }

  after_initialize  { self.session_token ||=SecureRandom::urlsafe_base64(16) }

  def self.find_by_credentials(user_name, password)
    user = User.find_by(user_name: user_name)
    return unless user
    user.is_password?(password) ? user : nil
  end

  def reset_session_token!
    self.session_token = SecureRandom::urlsafe_base64(16)
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    password_digest.is_password?(password)
  end

  private

  def password_digest
    BCrypt::Password.new(super)
  end

end
