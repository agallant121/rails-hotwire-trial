require "set"

class PhotosController < ApplicationController
  def index
    @pagy, @photos = pagy(:offset, Photo.order(:id), limit: 20)
    @liked_photo_ids = current_user.likes.where(photo_id: @photos.select(:id)).pluck(:photo_id).to_set
  end
end
