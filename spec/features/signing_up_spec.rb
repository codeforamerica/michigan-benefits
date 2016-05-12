require "rails_helper"

describe "signing up" do
  specify do
    visit root_path
    click_on "Sign Up"

    fill_in "Name", with: "Alice Aardvark"
    fill_in "Email", with: "alice@example.com"
    fill_in "Password", with: "password"
    click_button "Continue"

    expect(page).to have_css ".logged-in-as", text: "Alice Aardvark"
    expect(page).not_to have_css ".button", text: "Sign Up"

    new_user = User.last
    expect(new_user.name).to eq "Alice Aardvark"
    expect(new_user.email).to eq "alice@example.com"

    click_on "Log Out"
    expect(page).not_to have_css ".logged-in-as"
    expect(page).to have_css ".button", text: "Sign Up"
  end
end
