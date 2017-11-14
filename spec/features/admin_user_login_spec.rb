require "rails_helper"

RSpec.feature "Admin user login" do
  scenario "admin not logged in" do
    admin_user = create(:admin_user)

    visit admin_root_path
    fill_in "Email", with: admin_user.email
    fill_in "Password", with: admin_user.password
    click_on "Log in"

    expect(current_path).to eq "/"
    expect(page).to have_content("Signed in successfully")
  end
end
