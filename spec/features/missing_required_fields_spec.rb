require "rails_helper"

RSpec.feature "Missing required fields" do
  scenario "Renders errors while preserving other inputs", :js do
    visit root_path
    within(".slab--hero") { proceed_with "Apply for FAP" }

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
      proceed_with "Continue"
    end

    on_page "Your Location" do
      fill_in "Street address", with: "123 Main St."
      proceed_with "Continue"
    end

    on_page("Your Location") do
      expect(
        find_field("Street address").value,
      ).to eq "123 Main St."
    end
  end
end
