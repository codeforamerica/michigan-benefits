require "rails_helper"

RSpec.feature "Missing required fields" do
  scenario "Renders errors while preserving other inputs" do
    visit root_path
    click_on "Apply now"

    fill_in_name_and_birthday
    click_on "Continue"

    fill_in "What is the best phone number to reach you?", with: "2223334444"
    click_on "Continue"

    fill_in "Address", with: "123 Main St."
    click_on "Continue"

    expect(
      find_field("Address").value,
    ).to eq "123 Main St."
  end
end
