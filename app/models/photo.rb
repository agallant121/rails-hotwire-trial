 class Photo < ApplicationRecord
  validates :pexels_id, :width, :height, :source_url, :photographer, :medium_url, presence: true
  validates :pexels_id, uniqueness: true
end
