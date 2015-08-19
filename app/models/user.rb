class User < ActiveRecord::Base
  attr_reader :password

  validates :user_name, :password_digest, presence: true
  validates :user_name, uniqueness: true
  validates :password, length: { minimum: 8, allow_nil: true }

  after_initialize  { self.session_token ||= SecureRandom::urlsafe_base64(16) }

  has_many :cats,
    class_name: "Cat",
    foreign_key: :user_id,
    primary_key: :id

  has_many :rental_requests,
    class_name: "CatRentalRequest",
    foreign_key: :user_id,
    primary_key: :id

  has_many :sessions

  def self.find_by_credentials(user_name, password)
    user = User.find_by(user_name: user_name)
    return unless user
    user.is_password?(password) ? user : nil
  end

  def reset_session_token!
    self.session_token = SecureRandom::urlsafe_base64(16)
    self.save!
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
