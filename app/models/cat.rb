require 'date'

class Cat < ActiveRecord::Base
  SEX = ['M', 'F']
  COLOR = ["black", "brown", "calico"]

  validates :birthdate, :color, :name, :sex, :user_id, presence: true
  validates :sex, inclusion: { in: SEX,
    message: "%{value} is not a valid sex" }
  validates :color, inclusion: { in: COLOR,
    message: "%{value} is not a valid color" }

  belongs_to :owner,
    class_name: "User",
    foreign_key: :user_id,
    primary_key: :id

  has_many :cat_rental_requests,
    dependent: :destroy

  def age
    (Date.today - self.birthdate).to_i / 365
  end
end
