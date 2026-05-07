class LikesController < ApplicationController
  before_action :set_photo

  def create
    current_user.likes.find_or_create_by!(photo: @photo)
    respond_with_like_button
  end

  def destroy
    current_user.likes.find_by(photo: @photo)&.destroy!
    respond_with_like_button
  end

  private

  def set_photo
    @photo = Photo.find(params[:photo_id])
  end

  def respond_with_like_button
    @photo.reload
    @liked = current_user.likes.exists?(photo: @photo)

    respond_to do |format|
      format.html { redirect_to photos_path }
      format.turbo_stream
    end
  end
end
