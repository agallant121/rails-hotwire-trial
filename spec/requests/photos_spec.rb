require "rails_helper"

RSpec.describe "Photos", type: :request do
  it "shows all photos to signed in users" do
    user = User.create!(
      email: "viewer@example.com",
      password: "password",
      password_confirmation: "password"
    )

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

    post user_session_path, params: {
      user: {
        email: user.email,
        password: "password"
      }
    }

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
  end
end
