require "rails_helper"

RSpec.describe "Likes", type: :request do
  let(:user) do
    User.create!(
      email: "viewer@example.com",
      password: "password",
      password_confirmation: "password"
    )
  end

  let(:photo) do
    Photo.create!(
      pexels_id: 1,
      width: 1200,
      height: 900,
      source_url: "https://example.com/photo",
      photographer: "Jane Doe",
      medium_url: "https://example.com/photo.jpg",
      alt: "A sample photo"
    )
  end

  before do
    post user_session_path, params: {
      user: {
        email: user.email,
        password: "password"
      }
    }
  end

  it "lets a signed in user like a photo without a full page reload" do
    post photo_like_path(photo), headers: { "Accept" => "text/vnd.turbo-stream.html" }

    expect(response.media_type).to eq("text/vnd.turbo-stream.html")
    expect(response.body).to include(%(target="like_photo_#{photo.id}"))
    expect(response.body).to include("star-fill")
    expect(photo.reload.likes_count).to eq(1)
    expect(user.likes.where(photo: photo).count).to eq(1)
  end

  it "lets a signed in user unlike a photo without a full page reload" do
    user.likes.create!(photo: photo)

    delete photo_like_path(photo), headers: { "Accept" => "text/vnd.turbo-stream.html" }

    expect(response.media_type).to eq("text/vnd.turbo-stream.html")
    expect(response.body).to include(%(target="like_photo_#{photo.id}"))
    expect(response.body).to include("star-line")
    expect(photo.reload.likes_count).to eq(0)
    expect(user.likes.where(photo: photo).count).to eq(0)
  end

  it "does not count the same user's like more than once" do
    2.times do
      post photo_like_path(photo), headers: { "Accept" => "text/vnd.turbo-stream.html" }
    end

    expect(photo.reload.likes_count).to eq(1)
    expect(user.likes.where(photo: photo).count).to eq(1)
  end

  it "redirects signed out users who try to like a photo" do
    delete destroy_user_session_path

    post photo_like_path(photo)

    expect(response).to redirect_to(new_user_session_path)
  end
end
