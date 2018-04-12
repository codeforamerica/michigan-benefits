require "rails_helper"

RSpec.feature "Integrated application" do
  include PdfHelper

  scenario "where applicant is not a resident", :js do
    visit combined_home_path

    within(".slab--hero") do
      proceed_with "Apply for FAP and Medicaid"
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
