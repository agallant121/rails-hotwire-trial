class Photo < ApplicationRecord
  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user

  validates :pexels_id, :width, :height, :source_url, :photographer, :medium_url, presence: true
  validates :pexels_id, uniqueness: true
end
