require "rails_helper"

describe "authenticating", js: true do
  def expect_to_be_logged_in
    expect(page).to have_css ".logged-in-as", text: "Alice Aardvark"
    expect(page).not_to have_css ".top-bar a", text: "Sign Up"
  end

  def expect_to_be_logged_out
    expect(page).not_to have_css ".logged-in-as"
    expect(page).to have_css ".top-bar a", text: "Sign Up"
  end

  specify do
    visit root_path

    step "sign up with missing password" do
      click_on "Sign Up"

      fill_in "Name", with: "Alice Aardvark"
      fill_in "Email", with: "alice@example.com"
      click_button "Continue"
      expect_to_be_logged_out
    end

    step "sign up with password" do
      fill_in "Password", with: "password"
      click_button "Continue"

      expect_to_be_logged_in
      new_user = User.last
      expect(new_user.name).to eq "Alice Aardvark"
      expect(new_user.email).to eq "alice@example.com"
    end

    step "log out" do
      click_on "Log Out"
      expect_to_be_logged_out
    end

    step "log in with bad password" do
      click_on "Log In"

      fill_in "Email", with: "alice@example.com"
      fill_in "Password", with: "WRONG"
      click_button "Continue"

      expect_to_be_logged_out
      expect(flash).to eq "Email or password is invalid"
    end

    step "log in with good password" do
      fill_in "Email", with: "alice@example.com"
      fill_in "Password", with: "password"
      click_button "Continue"

      expect_to_be_logged_in
    end
  end
end
