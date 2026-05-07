require "rails_helper"

RSpec.describe "Authentication", type: :request do
  it "redirects signed out users to sign in" do
    get root_path

    expect(response).to redirect_to(new_user_session_path)
  end

  it "allows signed in users to view the protected root page" do
    User.create!(
      email: "user@example.com",
      password: "password",
      password_confirmation: "password"
    )

    post user_session_path, params: {
      user: {
        email: "user@example.com",
        password: "password"
      }
    }

    follow_redirect!

    expect(response).to have_http_status(:ok)
    expect(response.body).to include("All Photos")
  end
end
