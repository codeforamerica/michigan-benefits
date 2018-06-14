require "rails_helper"

RSpec.feature "Integrated application" do
  before do
    ENV["INTEGRATED_APPLICATION_ENABLED"] = "true"
  end

  after do
    ENV["INTEGRATED_APPLICATION_ENABLED"] = "false"
  end

  scenario "where applicant is not a resident and is applying for both programs", :js do
    visit root_path

    within(".slab--hero") do
      proceed_with "Start your application"
    end

    on_page "Introduction" do
      expect(page).to have_content("Which programs do you want to apply for today?")

      check "Food Assistance Program"
      check "Healthcare Coverage"

      proceed_with "Continue"
    end

    on_page "Introduction" do
      expect(page).to have_content("Welcome")

      proceed_with "Continue"
    end

    on_page "Introduction" do
      expect(page).to have_content("Do you currently reside in Michigan?")

      proceed_with "No"
    end

    on_page "Introduction" do
      expect(page).to have_content("Visit Healthcare.gov")
      expect(page).to have_content("Visit FNS.USDA.gov")
    end
  end

  scenario "where applicant is not a resident and is applying only for SNAP", :js do
    visit root_path

    within(".slab--hero") do
      proceed_with "Start your application"
    end

    on_page "Introduction" do
      expect(page).to have_content("Which programs do you want to apply for today?")

      check "Food Assistance Program"

      proceed_with "Continue"
    end

    on_page "Introduction" do
      expect(page).to have_content("Welcome")

      proceed_with "Continue"
    end

    on_page "Introduction" do
      expect(page).to have_content("Do you currently reside in Michigan?")

      proceed_with "No"
    end

    on_page "Introduction" do
      expect(page).to have_content("Visit FNS.USDA.gov")
      expect(page).to_not have_content("Visit Healthcare.gov")
    end
  end

  scenario "where applicant is not a resident and is applying only for Medicaid", :js do
    visit root_path

    within(".slab--hero") do
      proceed_with "Start your application"
    end

    on_page "Introduction" do
      expect(page).to have_content("Which programs do you want to apply for today?")

      check "Healthcare Coverage"

      proceed_with "Continue"
    end

    on_page "Introduction" do
      expect(page).to have_content("Welcome")

      proceed_with "Continue"
    end

    on_page "Introduction" do
      expect(page).to have_content("Do you currently reside in Michigan?")

      proceed_with "No"
    end

    on_page "Introduction" do
      expect(page).to have_content("Visit Healthcare.gov")
      expect(page).to_not have_content("Visit FNS.USDA.gov")
    end
  end
end
