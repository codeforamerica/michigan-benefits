require "rails_helper"

RSpec.feature "Integrated application" do
  include PdfHelper

  scenario "with one member", :js do
    visit combined_home_path

    within(".slab--hero") do
      proceed_with "Apply for FAP and Medicaid"
    end

    on_page "Introduction" do
      expect(page).to have_content("Do you currently reside in Michigan?")

      proceed_with "Yes"
    end

    on_page "Introduction" do
      expect(page).to have_content("To start, please introduce yourself")

      fill_in "What's your first name?", with: "Jessie"
      fill_in "What's your last name?", with: "Tester"

      fill_in "Month", with: "1"
      fill_in "Day", with: "1"
      fill_in "Year", with: "1998"

      select_radio(question: "What's your sex?", answer: "Female")

      select_radio(
        question: "Have you received assistance in Michigan in the past (or currently)?",
        answer: "Yes",
      )

      proceed_with "Continue"
    end

    on_page "Introduction" do
      expect(page).to have_content("What's your current living situation?")

      select_radio(
        question: "What's your current living situation?",
        answer: "Temporary address",
      )

      proceed_with "Continue"
    end

    on_page "Your Household" do
      expect(page).to have_content(
        "Who do you want to include on your Food Assistance application?",
      )

      proceed_with "Continue"
    end

    on_page "Review" do
      expect(page).to have_content(
        "Here's who's applying for Food Assistance with you:",
      )

      within "#applying-with-you" do
        expect(page).to have_content("Jessie Tester (that's you!)")
      end

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

      proceed_with "Yes"
    end

    on_page "Healthcare" do
      expect(page).to have_content("Is there anyone else who can be included on your tax return?")

      within "#tax-included" do
        expect(page).to have_content("Jessie Tester")
      end

      proceed_with "Continue"
    end

    on_page "Household" do
      expect(page).to have_content("Are you married?")

      proceed_with "Yes"
    end

    on_page "Students" do
      expect(page).to have_content("Are you a college or vocational school student?")

      proceed_with "Yes"
    end

    on_page "Disability" do
      expect(page).to have_content("Do you have a disability?")

      proceed_with "Yes"
    end

    on_page "Veterans" do
      expect(page).to have_content("Are you a veteran of the military?")

      proceed_with "Yes"
    end

    on_page "Foster Care" do
      expect(page).to have_content("Were you in foster care when you turned 18?")

      proceed_with "Yes"
    end

    on_page "Citizenship" do
      expect(page).to have_content("Are you currently a US Citizen?")

      proceed_with "Yes"
    end

    on_page "Current Healthcare" do
      expect(page).to have_content("Are you currently enrolled in a health insurance plan?")

      proceed_with "Yes"
    end

    on_page "Medical Bills" do
      expect(page).to have_content(
        "Do you need help paying for medical bills from the last 3 months?",
      )

      proceed_with "Yes"
    end

    on_page "Pregnancy" do
      expect(page).to have_content("Are you pregnant?")

      proceed_with "Yes"
    end

    on_page "Pregnancy" do
      expect(page).to have_content("Are you expecting more than one baby?")

      fill_in "form[baby_count]", with: "1"

      proceed_with "Continue"
    end

    on_page "Pregnancy" do
      expect(page).to have_content(
        "Do you have medical bills related to pregnancy from the last three months?",
      )

      proceed_with "Yes"
    end

    on_page "Flint Water Crisis" do
      expect(page).to have_content(
        "Have you been affected by the Flint Water Crisis?",
      )

      proceed_with "Yes"
    end

    on_page "Income" do
      expect(page).to have_content(
        "Has your income changed in the past 30 days?",
      )

      proceed_with "Yes"
    end

    on_page "Income" do
      expect(page).to have_content(
        "In your own words, tell us about the recent change in your income.",
      )

      fill_in "form[income_changed_explanation]", with: "I lost my job."

      proceed_with "Continue"
    end

    on_page "Jobs" do
      expect(page).to have_content(
        "Do you currently have a job?",
      )

      proceed_with "Yes"
    end

    on_page "Jobs" do
      expect(page).to have_content(
        "How many jobs do you have?",
      )

      fill_in "How many jobs do you have?", with: "1"

      proceed_with "Continue"
    end

    on_page "Self-Employment" do
      expect(page).to have_content(
        "Are you self-employed in any way?",
      )

      proceed_with "Yes"
    end

    on_page "Application Submitted" do
      expect(page).to have_content(
        "Congratulations",
      )
    end
  end
end
