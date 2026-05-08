module PhotoHelpers
  def create_photo(index)
    Photo.create!(
      pexels_id: index,
      width: 1200 + index,
      height: 900 + index,
      source_url: "https://example.com/photos/#{index}",
      photographer: "Photographer #{index}",
      medium_url: "https://example.com/photos/#{index}.jpg",
      alt: "Photo #{index}"
    )
  end
end
