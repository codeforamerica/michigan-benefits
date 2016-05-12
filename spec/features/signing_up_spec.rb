require "rails_helper"

describe "signing up" do
  specify do
    visit root_path
    click_on "Sign Up"

    fill_in "Name", with: "Alice Aardvark"
    fill_in "Email", with: "alice@example.com"
    fill_in "Password", with: "password"
    click_button "Continue"

    expect(find(".logged-in-as").text).to eq "Alice Aardvark"

    new_user = User.last
    expect(new_user.name).to eq "Alice Aardvark"
    expect(new_user.email).to eq "alice@example.com"
  end
end
