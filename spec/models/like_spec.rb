require "rails_helper"

RSpec.describe Like, type: :model do
  let(:user) do
    User.create!(
      email: "user@example.com",
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

  it "allows a user to like a photo once" do
    described_class.create!(user: user, photo: photo)

    duplicate = described_class.new(user: user, photo: photo)

    expect(duplicate).not_to be_valid
    expect(duplicate.errors).to include(:user_id)
  end

  it "updates the photo like count" do
    like = described_class.create!(user: user, photo: photo)

    expect(photo.reload.likes_count).to eq(1)

    like.destroy!

    expect(photo.reload.likes_count).to eq(0)
  end
end
