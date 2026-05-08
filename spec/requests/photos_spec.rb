require "rails_helper"

RSpec.describe "Photos", type: :request do
  let(:user) do
    User.create!(
      email: "viewer@example.com",
      password: "password",
      password_confirmation: "password"
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

  it "shows all provided photos to signed in users" do
    photos = 10.times.map { |index| create_photo(index + 1) }
    user.likes.create!(photo: photos.first)

    get photos_path

    expect(response).to have_http_status(:ok)

    page = response.body
    expect(page).to include("10 photos")
    expect(page).to include("@hotwired/turbo-rails")

    photos.each do |photo|
      expect(page).to include(photo.photographer)
      expect(page).to include(photo.source_url)
      expect(page).to include(photo.medium_url)
      expect(page).to include(photo.alt)
      expect(page).to include("like_photo_#{photo.id}")
    end

    expect(page).to include("Source")
    expect(page).to include("star-fill")
    expect(page).to include("star-line")
  end

  it "shows an empty state when no photos exist" do
    get photos_path

    expect(response).to have_http_status(:ok)
    page = response.body

    expect(page).to include("0 photos")
    expect(page).to include("No photos yet")
    expect(page).to include("Seed the database to add photos to the gallery.")
  end

  it "paginates larger photo sets with turbo streams" do
    25.times { |index| create_photo(index + 1) }

    get photos_path
    page = response.body
    expect(page).to include("Photographer 20")
    expect(page).not_to include("Photographer 21")
    expect(page).to include("Next")

    get photos_path(page: 2), headers: { "Accept" => "text/vnd.turbo-stream.html" }
    turbo_stream = response.body

    expect(response.media_type).to eq("text/vnd.turbo-stream.html")
    expect(turbo_stream).to include(%(target="photo-results"))
    expect(turbo_stream).to include("Photographer 21")
    expect(turbo_stream).to include("Photographer 25")
    expect(turbo_stream).not_to include("Photographer 20")
  end
end
