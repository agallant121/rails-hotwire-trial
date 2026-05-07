class User < ApplicationRecord
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable

  has_many :likes, dependent: :destroy
  has_many :liked_photos, through: :likes, source: :photo
end
