require "rails_helper"

RSpec.feature "Integrated application" do
  scenario "where applicant is not a resident and is applying for both programs" do
    visit root_path

    within(".slab--hero") do
      click_on "Start your application"
    end

    on_page "Introduction" do
      expect(page).to have_content("Which programs do you want to apply for today?")

      check "Food Assistance Program"
      check "Healthcare Coverage"

      click_on "Continue"
    end

    on_page "Introduction" do
      expect(page).to have_content("Welcome")

      click_on "Continue"
    end

    on_page "Introduction" do
      expect(page).to have_content("Do you currently reside in Michigan?")

      click_on "No"
    end

    on_page "Introduction" do
      expect(page).to have_content("Visit Healthcare.gov")
      expect(page).to have_content("Visit FNS.USDA.gov")
    end
  end

  scenario "where applicant is not a resident and is applying only for SNAP" do
    visit root_path

    within(".slab--hero") do
      click_on "Start your application"
    end

    on_page "Introduction" do
      expect(page).to have_content("Which programs do you want to apply for today?")

      check "Food Assistance Program"

      click_on "Continue"
    end

    on_page "Introduction" do
      expect(page).to have_content("Welcome")

      click_on "Continue"
    end

    on_page "Introduction" do
      expect(page).to have_content("Do you currently reside in Michigan?")

      click_on "No"
    end

    on_page "Introduction" do
      expect(page).to have_content("Visit FNS.USDA.gov")
      expect(page).to_not have_content("Visit Healthcare.gov")
    end
  end

  scenario "where applicant is not a resident and is applying only for Medicaid" do
    visit root_path

    within(".slab--hero") do
      click_on "Start your application"
    end

    on_page "Introduction" do
      expect(page).to have_content("Which programs do you want to apply for today?")

      check "Healthcare Coverage"

      click_on "Continue"
    end

    on_page "Introduction" do
      expect(page).to have_content("Welcome")

      click_on "Continue"
    end

    on_page "Introduction" do
      expect(page).to have_content("Do you currently reside in Michigan?")

      click_on "No"
    end

    on_page "Introduction" do
      expect(page).to have_content("Visit Healthcare.gov")
      expect(page).to_not have_content("Visit FNS.USDA.gov")
    end
  end
end
