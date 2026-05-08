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
    photos = 10.times.map do |index|
      Photo.create!(
        pexels_id: index + 1,
        width: 1200 + index,
        height: 900 + index,
        source_url: "https://example.com/photos/#{index + 1}",
        photographer: "Photographer #{index + 1}",
        medium_url: "https://example.com/photos/#{index + 1}.jpg",
        alt: "Photo #{index + 1}"
      )
    end
    user.likes.create!(photo: photos.first)

    get photos_path

    expect(response).to have_http_status(:ok)
    expect(response.body).to include("10 photos")
    expect(response.body).to include("@hotwired/turbo-rails")

    page = Nokogiri::HTML(response.body)

    photos.each do |photo|
      card = page.at_css("##{ActionView::RecordIdentifier.dom_id(photo)}")

      expect(card).to be_present
      expect(card.text).to include(photo.photographer)
      expect(card.at_css(%(a[href="#{photo.source_url}"]))).to be_present
      expect(card.at_css(%(img[src="#{photo.medium_url}"]))).to be_present
      expect(card.at_css(%(img[alt="#{photo.alt}"]))).to be_present
      expect(card.css(".like-icon").size).to eq(1)
      expect(card.css(".source-icon").size).to eq(1)
      expect(card.at_css(%(turbo-frame[id="like_photo_#{photo.id}"]))).to be_present
    end

    first_card = page.at_css("##{ActionView::RecordIdentifier.dom_id(photos.first)}")
    second_card = page.at_css("##{ActionView::RecordIdentifier.dom_id(photos.second)}")

    expect(first_card.at_css(".like-button.liked")).to be_present
    expect(second_card.at_css(".like-button.liked")).to be_nil
  end
it "shows an empty state when no photos exist" do
    get photos_path

    expect(response).to have_http_status(:ok)
    expect(response.body).to include("0 photos")
    expect(response.body).to include("No photos yet")
    expect(response.body).to include("Seed the database to add photos to the gallery.")
  end

  it "paginates larger photo sets with turbo streams" do
    25.times do |index|
      Photo.create!(
        pexels_id: index + 1,
        width: 1200 + index,
        height: 900 + index,
        source_url: "https://example.com/photos/#{index + 1}",
        photographer: "Photographer #{index + 1}",
        medium_url: "https://example.com/photos/#{index + 1}.jpg",
        alt: "Photo #{index + 1}"
      )
    end

    get photos_path

    expect(response.body).to include("Photographer 20")
    expect(response.body).not_to include("Photographer 21")
    expect(response.body).to include("Next")

    get photos_path(page: 2), headers: { "Accept" => "text/vnd.turbo-stream.html" }

    expect(response.media_type).to eq("text/vnd.turbo-stream.html")
    expect(response.body).to include(%(target="photo-results"))
    expect(response.body).to include("Photographer 21")
    expect(response.body).to include("Photographer 25")
    expect(response.body).not_to include("Photographer 20")
  end
end
