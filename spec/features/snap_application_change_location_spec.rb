require "rails_helper"

RSpec.feature "Submit snap application" do
  scenario "change office location" do
    visit root_path
    within(".slab--hero") { click_on "Apply now" }

    on_page "Introduction" do
      fill_in_name_and_birthday
      click_on "Continue"
    end

    fill_in "What is the best phone number to reach you?", with: "2222222222"
    click_on "Continue"

    fill_in "Address", with: "123 Main St"
    fill_in "City", with: "Flint"
    fill_in "ZIP code", with: "48411"
    select_address_same_as_home_address
    click_on "Continue"

    within(".form-card__content") do
      expect(page).to have_content("Union Street")
    end

    on_page "Introduction Complete" do
      click_on "here"
    end

    on_page "Office Submission" do
      expect(page).to have_content(
        "Where would you like to submit your application?",
      )
      choose "Clio Road"
      click_on "Continue"
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
