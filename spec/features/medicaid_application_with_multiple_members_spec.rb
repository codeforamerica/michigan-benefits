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
      expect(page).to have_content(
        "Is everyone in your household currently a US citizen",
      )
      click_on "No"
    end

    on_page "Introduction" do
      expect(page).to have_content(
        "Tell us who in your household is not currently a US citizen",
      )
      check "Jessie Tester"
      click_on "Next"
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

    on_pages "Health Coverage Needs" do
      expect(page).to have_content(
        "Are you currently enrolled in a health insurance plan?",
      )
      click_on "No"

      expect(page).to have_content(
        "Do you need help paying for medical expenses from the last 3 months?",
      )
      click_on "No"
    end

    on_pages "Quick Health Questions" do
      expect(page).to have_content("Do you have a disability?")
      click_on "No"

      expect(page).to have_content("Have you been pregnant recently?")
      click_on "No"

      expect(page).to have_content(
        "Have you or someone in your household been affected by the Flint" +
        " Water Crisis?",
      )
      click_on "Yes"

      expect(page).to have_content("We've noted this on your application.")
      click_on "Next"
    end

    on_pages "Quick Tax Question" do
      expect(page).to have_content(
        "Do you plan on filing a federal tax return next year?",
      )

      click_on "Yes"
    end

    on_pages "Current Income" do
      expect(page).to have_content(
        "Does anyone in your household currently have a job?",
      )
      click_on "Yes"

      expect(page).to have_content(
        "Tell us who in your household has one or more jobs.",
      )
      select_job_number(full_name: "Christa Tester", job_number: "2 jobs")
      click_on "Next"

      expect(page).to have_content("Are you self-employed?")
    end
  end
end
