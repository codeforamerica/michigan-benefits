require "rails_helper"

RSpec.feature "Mailing and residential addresses" do
  scenario "home address not same as mailing address", :js do
    visit root_path
    within(".slab--hero") { click_on "Apply for FAP" }

    on_page "Introduction" do
      expect(page).to have_content("Food Assistance Application")
      fill_in_name_and_birthday
      proceed_with "Continue"
    end

    on_page "Office" do
      select_radio(
        question: "Which office are you in?",
        answer: "I'm not in an office",
      )
      proceed_with "Continue"
    end

    on_page "Contact Information" do
      fill_in "What is the best phone number to reach you?", with: "2024561111"
      fill_in "What is your email address?", with: "test@example.com"
      click_on "Continue"
    end

    on_page "Your Location" do
      fill_in "Street address", with: "123 Main St"
      fill_in "City", with: "Flint"
      fill_in "ZIP code", with: "12345"
      select_address_not_same_as_home_address
      click_on "Continue"
    end

    expect(current_path).to eq "/steps/residential-address"
    fill_in "Street address", with: "456 Hello St"
    fill_in "City", with: "Flint"
    fill_in "ZIP code", with: "12345"
    select_unstable_address
    click_on "Continue"

    expect(current_path).to eq "/steps/introduction-complete"
  end

  scenario "goes back after skipping residential address step", :js do
    visit root_path
    within(".slab--hero") { click_on "Apply for FAP" }

    on_page "Introduction" do
      expect(page).to have_content("Food Assistance Application")
      fill_in_name_and_birthday
      proceed_with "Continue"
    end

    on_page "Office" do
      select_radio(
        question: "Which office are you in?",
        answer: "I'm not in an office",
      )
      proceed_with "Continue"
    end

    on_page "Contact Information" do
      fill_in "What is the best phone number to reach you?", with: "2024561111"
      fill_in "What is your email address?", with: "test@example.com"
      click_on "Continue"
    end

    on_page "Your Location" do
      fill_in "Street address", with: "123 Main St"
      fill_in "City", with: "Flint"
      fill_in "ZIP code", with: "12345"
      select_address_same_as_home_address
      click_on "Continue"
    end

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
