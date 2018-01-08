require "rails_helper"

RSpec.feature "Submit snap application" do
  scenario "change office location", :js do
    visit root_path
    within(".slab--hero") { proceed_with "Apply for FAP" }

    on_page "Introduction" do
      fill_in_name_and_birthday
      proceed_with "Continue"
    end

    fill_in "What is the best phone number to reach you?", with: "2222222222"
    proceed_with "Continue"

    fill_in "Address", with: "123 Main St"
    fill_in "City", with: "Flint"
    fill_in "ZIP code", with: "48411"
    select_address_same_as_home_address
    proceed_with "Continue"

    within(".form-card__content") do
      expect(page).to have_content("Union Street")
    end

    on_page "Introduction Complete" do
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
