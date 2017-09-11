require "rails_helper"

RSpec.feature "Mailing and residential addresses" do
  scenario "home address not same as mailing address" do
    visit root_path
    click_on "Apply now"

    fill_in_name_and_birthday
    click_on "Continue"

    fill_in "What is the best phone number to reach you?", with: "2223334444"
    fill_in "What is your email address?", with: "test@example.com"
    click_on "Continue"

    fill_in "Address", with: "123 Main St"
    fill_in "City", with: "Flint"
    fill_in "ZIP code", with: "12345"
    select_address_not_same_as_home_address
    click_on "Continue"

    expect(current_path).to eq "/steps/residential-address"
    fill_in "Address", with: "456 Hello St"
    fill_in "City", with: "Flint"
    fill_in "ZIP code", with: "12345"
    select_unstable_address
    click_on "Continue"

    expect(current_path).to eq "/steps/introduction-complete"
  end

  scenario "goes back after skipping residential address step" do
    visit root_path
    click_on "Apply now"

    fill_in_name_and_birthday
    click_on "Continue"

    fill_in "What is the best phone number to reach you?", with: "2223334444"
    fill_in "What is your email address?", with: "test@example.com"
    click_on "Continue"

    fill_in "Address", with: "123 Main St"
    fill_in "City", with: "Flint"
    fill_in "ZIP code", with: "12345"
    select_address_same_as_home_address
    click_on "Continue"

    find(".step-header__back-link").click

    expect(current_path).to eq "/steps/mailing-address"
  end

  def select_unstable_address
    check "Check this box if you do not have a stable address"
  end

  def select_address_not_same_as_home_address
    select_radio(
      question: "Is this address the same as your home address?",
      answer: "No",
    )
  end
end
