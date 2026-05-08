require "rails_helper"

RSpec.describe "Photo gallery", type: :system do
  before do
    driven_by :selenium, using: :headless_chrome, screen_size: [ 1400, 1400 ]
  end

  let!(:user) do
    User.create!(
      email: "viewer-#{SecureRandom.hex(4)}@example.com",
      password: "password",
      password_confirmation: "password"
    )
  end

  def sign_in
    visit new_user_session_path
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Sign in"

    expect(page).to have_content("All Photos")
  end

  it "lets an existing user sign in and view photos" do
    create_photo(1)

    sign_in

    expect(page).to have_current_path(root_path)
    expect(page).to have_content("All Photos")
    expect(page).to have_content("Photographer 1")
    expect(page).to have_link("Source", href: "https://example.com/photos/1")
  end

  it "shows a no photos message when the gallery is empty" do
    sign_in

    expect(page).to have_content("0 photos")
    expect(page).to have_content("No photos yet")
    expect(page).to have_content("Seed the database to add photos to the gallery.")
  end

  it "lets a user like and unlike a photo without leaving the gallery" do
    photo = create_photo(1)

    sign_in

    within "##{ActionView::RecordIdentifier.dom_id(photo, :like)}" do
      expect(page).to have_button("0")

      click_button "0"

      expect(page).to have_button("1")

      click_button "1"

      expect(page).to have_button("0")
    end

    expect(page).to have_current_path(root_path)
    expect(photo.reload.likes_count).to eq(0)
  end

  it "lets a user paginate through larger photo sets" do
    25.times { |index| create_photo(index + 1) }

    sign_in

    expect(page).to have_content("Photographer 20")
    expect(page).to have_no_content("Photographer 25")

    click_link "Next"

    expect(page).to have_content("Photographer 25")
    expect(page).to have_no_content("Photographer 20")
    expect(page).to have_content("Page 2 of 2")
  end
end
