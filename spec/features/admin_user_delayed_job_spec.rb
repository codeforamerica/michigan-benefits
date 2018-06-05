require "rails_helper"

RSpec.feature "Admin user access Delayed Job web" do
  context "admin not logged in" do
    scenario "redirected to sign-in page" do
      visit "/delayed_job"

      expect(page).to have_content "Log in"
      expect(page).to have_content "Email"
      expect(page).to have_content "Password"
    end
  end

  context "admin signs in" do
    scenario "sees successfull sign-in message" do
      create(:admin_user, email: "test@example.com", password: "password")
      visit "/delayed_job"

      fill_in "Email", with: "test@example.com"
      fill_in "Password", with: "password"
      click_on "Log in"

      expect(page).to have_content("Signed in successfully")
    end
  end
end
