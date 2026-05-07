require "set"

class PhotosController < ApplicationController
  def index
    @photos = Photo.order(:id)
    @liked_photo_ids = current_user.likes.where(photo: @photos).pluck(:photo_id).to_set
  end
end
