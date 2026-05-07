
require "rails_helper"

RSpec.describe Photo, type: :model do
  let(:valid_attributes) do
    {
      pexels_id: 1,
      width: 1200,
      height: 900,
      source_url: "https://example.com/photo",
      photographer: "Jane Doe",
      medium_url: "https://example.com/photo.jpg",
      alt: "A sample photo"
    }
  end

  it "is valid with required attributes" do
    expect(described_class.new(valid_attributes)).to be_valid
  end

  it "requires gallery fields" do
    photo = described_class.new

    expect(photo).not_to be_valid
    expect(photo.errors).to include(:pexels_id, :width, :height, :source_url, :photographer, :medium_url)
  end

  it "requires a unique pexels id" do
    described_class.create!(valid_attributes)

    duplicate = described_class.new(valid_attributes)

    expect(duplicate).not_to be_valid
    expect(duplicate.errors).to include(:pexels_id)
  end
end
