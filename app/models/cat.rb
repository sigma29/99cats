require 'date'

class Cat < ActiveRecord::Base
  SEX = ['M', 'F']
  COLOR = ["black", "brown", "calico"]

  validates :birthdate, :color, :name, :sex, presence: true
  validates :sex, inclusion: { in: SEX,
    message: "%{value} is not a valid sex" }
  validates :color, inclusion: { in: COLOR,
    message: "%{value} is not a valid color" }

  has_many :cat_rental_requests,
    dependent: :destroy

  def age
    (Date.today - self.birthdate).to_i / 365
  end
end
