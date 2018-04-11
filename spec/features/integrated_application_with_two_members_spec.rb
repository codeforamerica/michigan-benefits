require "rails_helper"

RSpec.feature "Integrated application" do
  include PdfHelper

  scenario "with two members", :js do
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

      select_radio(
        question: "Have you received assistance in Michigan in the past (or currently)?",
        answer: "Yes",
      )

      proceed_with "Continue"
    end

    on_page "Introduction" do
      expect(page).to have_content("Do you currently reside in Michigan?")

      proceed_with "Yes"
    end

    on_page "Introduction" do
      expect(page).to have_content("What's your current living situation?")

      select_radio(
        question: "What's your current living situation?",
        answer: "Stable address",
      )

      proceed_with "Continue"
    end

    on_page "Introduction" do
      expect(page).to have_content("Every family is different")

      proceed_with "Continue"
    end

    on_page "Your Household" do
      expect(page).to have_content(
        "Who do you currently live with?",
      )

      click_on "Add a member"
    end

    on_page "Your Household" do
      expect(page).to have_content("Add a person you want to apply with")

      fill_in "What's their first name?", with: "Jonny"
      fill_in "What's their last name?", with: "Tester"
      select "Roommate", from: "What is their relationship to you?"

      proceed_with "Continue"
    end

    on_page "Your Household" do
      expect(page).to have_content(
        "Who do you currently live with?",
      )

      expect(page).to have_content("Jonny Tester")

      proceed_with "Continue"
    end

    on_page "Your Household" do
      expect(page).to have_content(
        "Who do you want to include on your Food Assistance application?",
      )

      # Jessie Tester checked by default
      check "Jonny Tester"

      proceed_with "Continue"
    end

    on_page "Your Household" do
      expect(page).to have_content(
        "Do you and Jonny share meals and food costs?",
      )

      proceed_with "No"
    end

    on_page "Review" do
      expect(page).to have_content(
        "Here's who's applying for Food Assistance with you:",
      )

      within "#applying-with-you" do
        expect(page).to have_content("Jessie Tester (that's you!)")
      end

      within "#not-applying-with-you" do
        expect(page).to have_content("Jonny Tester")
      end

      proceed_with "Continue"
    end

    on_page "Healthcare" do
      expect(page).to have_content(
        "Which people also need Healthcare Coverage?",
      )

      # Jessie Tester checked by default
      check "Jonny Tester"

      proceed_with "Continue"
    end

    on_page "Healthcare" do
      expect(page).to have_content(
        "we'll ask you questions about how you file taxes",
      )

      proceed_with "Continue"
    end

    on_page "Healthcare" do
      expect(page).to have_content("Will you file taxes next year?")

      proceed_with "No"
    end

    on_page "Household" do
      expect(page).to have_content(
        "Is anyone in your household currently married?",
      )

      proceed_with "No"
    end

    on_page "Caretaker" do
      expect(page).to have_content(
        "Is anyone a caretaker or parent of other people in the household?",
      )

      proceed_with "No"
    end

    on_page "Students" do
      expect(page).to have_content(
        "Is anyone a college or vocational school student?",
      )

      proceed_with "No"
    end

    on_page "Disability" do
      expect(page).to have_content(
        "Does anyone have a disability?",
      )

      proceed_with "No"
    end

    on_page "Citizenship" do
      expect(page).to have_content("Is everyone currently a US Citizen?")

      proceed_with "Yes"
    end

    on_page "Veterans" do
      expect(page).to have_content("Is anyone a veteran of the military?")

      proceed_with "No"
    end

    on_page "Foster Care" do
      expect(page).to have_content("Was anyone in foster care when they turned 18?")

      proceed_with "No"
    end

    on_page "Pregnancy" do
      expect(page).to have_content("Is anyone pregnant?")

      proceed_with "No"
    end

    on_page "Pregnancy" do
      expect(page).to have_content(
        "Does anyone have medical bills related to pregnancy from the last three months?",
      )

      proceed_with "No"
    end

    on_page "Current Healthcare" do
      expect(page).to have_content("Is anyone currently enrolled in a health insurance plan?")

      proceed_with "No"
    end

    on_page "Medical Bills" do
      expect(page).to have_content(
        "Does anyone need help paying for medical bills from the last 3 months?",
      )

      proceed_with "No"
    end

    on_page "Flint Water Crisis" do
      expect(page).to have_content(
        "Has anyone been affected by the Flint Water Crisis?",
      )

      proceed_with "No"
    end

    on_page "Income" do
      expect(page).to have_content(
        "Has your household had a change in income in the past 30 days?",
      )

      proceed_with "No"
    end

    on_page "Jobs" do
      expect(page).to have_content(
        "Who currently has a job?",
      )

      fill_in "How many jobs do you have?", with: "0"
      fill_in "How many jobs does Jonny Tester have?", with: "0"

      proceed_with "Continue"
    end

    on_page "Application Submitted" do
      expect(page).to have_content(
        "Congratulations",
      )
    end
  end
end
