require "rails_helper"

RSpec.feature "Submit snap application" do
  scenario "change office location", :js, :single_app_flow do
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
      fill_in "Street address", with: "123 Main St"
      fill_in "City", with: "Flint"
      fill_in "ZIP code", with: "48411"
      select_address_same_as_home_address
      proceed_with "Continue"
    end

    on_page "Introduction Complete" do
      within(".form-card__content") do
        expect(page).to have_content("Union Street")
      end

      proceed_with "here"
    end

    on_page "Office Submission" do
      expect(page).to have_content(
        "Where would you like to submit your application?",
      )
      choose "Clio Road"
      proceed_with "Continue"
    end

    on_page "Introduction Complete" do
      within(".form-card__content") do
        expect(page).to have_content("Clio Road")
      end
    end

    visit "/steps/success"

    on_page "Application Submitted" do
      expect(page).to have_content(
        "Your application has been successfully " +
          "submitted to MDHHS on Clio Road.",
      )
    end
  end
end
