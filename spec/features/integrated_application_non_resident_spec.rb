require "rails_helper"

RSpec.feature "Integrated application" do
  include PdfHelper

  scenario "where applicant is not a resident", :js do
    visit combined_home_path

    within(".slab--hero") do
      proceed_with "Apply for FAP and Medicaid"
    end

    on_page "Introduction" do
      expect(page).to have_content("To start, please introduce yourself")

      fill_in "What's your first name?", with: "Jessie"
      fill_in "What's your last name?", with: "Tester"

      fill_in "Month", with: "1"
      fill_in "Day", with: "1"
      fill_in "Year", with: "1969"

      select_radio(question: "What's your sex?", answer: "Female")

      proceed_with "Continue"
    end

    on_page "Introduction" do
      expect(page).to have_content("Do you currently reside in Michigan?")

      proceed_with "No"
    end

    on_page "Introduction" do
      expect(page).to have_content("Visit Healthcare.gov to apply for health coverage.")
    end
  end
end
