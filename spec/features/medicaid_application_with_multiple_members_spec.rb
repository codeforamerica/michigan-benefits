require "rails_helper"

RSpec.feature "Medicaid app" do
  scenario "with multiple members", :js do
    visit medicaid_root_path

    within(".slab--hero") do
      click_on "Apply for Medicaid"
    end

    on_page "Introduction" do
      click_on "Yes"
    end

    on_page "Introduction" do
      fill_in "What is your first name?", with: "Jessie"
      fill_in "What is your last name?", with: "Tester"
      select_radio(question: "What is your gender?", answer: "Female")
      click_on "Next"
    end

    on_page "Introduction" do
      click_on "Add a member"
    end

    on_page "Introduction" do
      fill_in "What is their first name?", with: "Christa"
      fill_in "What is their last name?", with: "Tester"
      select_radio(question: "What is their gender?", answer: "Female")
      click_on "Next"
    end

    expect(page).to have_content("Jessie Tester")
    expect(page).to have_content("Christa Tester")
    click_on "Next"

    on_page "Introduction" do
      expect(page).to have_content("Is anyone currently a college student?")
      click_on "Yes"
    end

    on_page "Introduction" do
      expect(page).to have_content(
        "Tell us who is currently a college student.",
      )
      check "Jessie Tester"
      click_on "Next"
    end

    on_page "Introduction" do
      expect(page).to have_content("Are you currently a US Citizen?")
      click_on "Yes"
    end

    on_page "Health Coverage Needs" do
      expect(page).to have_content(
        "Who in your household needs healthcare coverage?",
      )
      uncheck "Jessie Tester"
      uncheck "Christa Tester"
      click_on "Next"
    end

    on_page "Health Coverage Needs" do
      expect(page).to have_content("Make sure you select at least one person")
      check "Jessie Tester"
      check "Christa Tester"
      click_on "Next"
    end

    expect(page).to have_content(
      "Are you currently enrolled in a health insurance plan?",
    )
  end
end
