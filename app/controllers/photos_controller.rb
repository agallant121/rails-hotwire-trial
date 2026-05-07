class PhotosController < ApplicationController
  def index
    @photos = Photo.order(:id)
  end
end
