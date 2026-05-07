require "csv"

User.find_or_create_by!(email: "demo@example.com") do |user|
  user.password = "password"
  user.password_confirmation = "password"
end

CSV.foreach(Rails.root.join("photos.csv"), headers: true) do |row|
  photo = Photo.find_or_initialize_by(pexels_id: row.fetch("id"))

  photo.update!(
    width: row.fetch("width"),
    height: row.fetch("height"),
    source_url: row.fetch("url"),
    photographer: row.fetch("photographer"),
    medium_url: row.fetch("src.medium"),
    alt: row["alt"]
  )
end
