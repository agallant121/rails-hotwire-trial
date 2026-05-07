require "csv"

["demo@example.com", "demo2@example.com"].each do |email|
  User.find_or_create_by!(email: email) do |user|
    user.password = "password"
    user.password_confirmation = "password"
  end
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

demo_user = User.find_by!(email: "demo@example.com")
demo_user_two = User.find_by!(email: "demo2@example.com")
photos = Photo.order(:id).limit(5).to_a

photos.first(4).each do |photo|
  demo_user.likes.find_or_create_by!(photo: photo)
end

photos.first(2).append(photos.fifth).each do |photo|
  demo_user_two.likes.find_or_create_by!(photo: photo)
end
