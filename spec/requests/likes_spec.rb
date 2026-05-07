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

  it "likes a photo with a turbo stream response" do
    post photo_like_path(photo), headers: { "Accept" => "text/vnd.turbo-stream.html" }

    expect(response.media_type).to eq("text/vnd.turbo-stream.html")
    expect(response.body).to include(%(target="like_photo_#{photo.id}"))
    expect(response.body).to include("star-fill")
    expect(photo.reload.likes_count).to eq(1)
    expect(user.likes.where(photo: photo).count).to eq(1)
  end

  it "unlikes a photo with a turbo stream response" do
    user.likes.create!(photo: photo)

    delete photo_like_path(photo), headers: { "Accept" => "text/vnd.turbo-stream.html" }

    expect(response.media_type).to eq("text/vnd.turbo-stream.html")
    expect(response.body).to include(%(target="like_photo_#{photo.id}"))
    expect(response.body).to include("star-line")
    expect(photo.reload.likes_count).to eq(0)
    expect(user.likes.where(photo: photo).count).to eq(0)
  end
end
