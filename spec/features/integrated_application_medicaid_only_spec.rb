require "rails_helper"

RSpec.feature "Medicaid-only integrated application" do
  before do
    ENV["INTEGRATED_APPLICATION_ENABLED"] = "true"
  end

  after do
    ENV["INTEGRATED_APPLICATION_ENABLED"] = "false"
  end

  scenario "with two members", :js do
    visit root_path

    within(".slab--hero") do
      proceed_with "Start your application"
    end

    on_page "Introduction" do
      expect(page).to have_content("Which programs do you want to apply for today?")

      check "Healthcare Coverage"
      uncheck "Food Assistance Program"

      proceed_with "Continue"
    end

    on_page "Introduction" do
      expect(page).to have_content("Welcome")

      proceed_with "Continue"
    end

    on_page "Introduction" do
      expect(page).to have_content("Do you currently reside in Michigan?")

      proceed_with "Yes"
    end

    on_page "Introduction" do
      expect(page).to have_content("Which office are you in?")

      choose "Clio Road"
      proceed_with "Continue"
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
      expect(page).to have_content("What's your current living situation?")

      select_radio(
        question: "What's your current living situation?",
        answer: "Stable address",
      )

      proceed_with "Continue"
    end

    on_page "Introduction" do
      expect(page).to have_content("What's your home address?")

      fill_in "Street address", with: "123 Main St"
      fill_in "Street address 2", with: "Apt B"
      fill_in "City", with: "Flint"
      fill_in "ZIP code", with: "48550"

      select_radio(
        question: "Is this also your mailing address?",
        answer: "Yes",
      )

      proceed_with "Continue"
    end

    on_page "Introduction" do
      expect(page).to have_content("What's the best number for you to receive phone calls?")

      proceed_with "Continue"
    end

    on_page "Your Household" do
      expect(page).to have_content("Okay thanks! Now tell us about your household.")

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

    on_page "Healthcare" do
      expect(page).to have_content(
        "Which people also need Healthcare Coverage?",
      )

      # Jessie Tester checked by default
      check "Jonny Tester"

      proceed_with "Continue"
    end

    on_page "Healthcare" do
      expect(page).to have_content("Will you file taxes next year?")

      proceed_with "No"
    end

    on_page "Household" do
      expect(page).to have_content("Getting to know you")

      proceed_with "Continue"
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

    on_page "Veterans" do
      expect(page).to have_content("Is anyone a veteran of the military?")

      proceed_with "No"
    end

    on_page "Foster Care" do
      expect(page).to have_content("Was anyone in foster care when they turned 18?")

      proceed_with "No"
    end

    on_page "Citizenship" do
      expect(page).to have_content("Is everyone currently a US Citizen?")

      proceed_with "Yes"
    end

    on_page "Household Expenses" do
      expect(page).to have_content("Does anyone pay for interest on student loans?")

      proceed_with "No"
    end

    on_page "Healthcare" do
      expect(page).to have_content("Health and insurance")

      proceed_with "Continue"
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

    on_page "Flint Water Crisis" do
      expect(page).to have_content(
        "Has anyone been affected by the Flint Water Crisis?",
      )

      proceed_with "No"
    end

    on_page "Income and Employment" do
      expect(page).to have_content("Income and employment")

      proceed_with "Continue"
    end

    on_page "Income and Employment" do
      expect(page).to have_content(
        "Tell us how many jobs everyone has.",
      )

      fill_in "How many jobs do you have?", with: "0"
      fill_in "How many jobs does Jonny Tester have?", with: "0"

      proceed_with "Continue"
    end

    on_page "Income and Employment" do
      expect(page).to have_content(
        "Is anyone self-employed in any way?",
      )

      proceed_with "No"
    end

    on_page "Income and Employment" do
      expect(page).to have_content(
        "Do you get income from any of these sources?",
      )

      proceed_with "Continue"
    end

    on_page "Income and Employment" do
      expect(page).to have_content(
        "Does Jonny get income from any of these sources?",
      )

      check "Unemployment"

      proceed_with "Continue"
    end

    on_page "Income and Employment" do
      expect(page).to have_content(
        "Tell us about Jonny's income sources",
      )

      fill_in "Unemployment", with: "100"

      proceed_with "Continue"
    end

    on_page "Finishing Up" do
      expect(page).to have_content("Finishing up")

      proceed_with "Continue"
    end

    on_page "Finishing Up" do
      expect(page).to have_content("Is there anything else you'd like us to know about your situation?")

      proceed_with "Continue"
    end

    on_page "Finishing Up" do
      expect(page).to have_content(
        "Provide your Social Security Number if you're ready",
      )

      fill_in "Social Security Number", with: "123456789"

      proceed_with "Continue"
    end

    on_page "Finishing Up" do
      expect(page).to have_content(
        "How can we follow up with you?",
      )

      proceed_with "Continue"
    end

    on_page "Finishing Up" do
      expect(page).to have_content(
        "Review your paperwork",
      )

      proceed_with "I'll do this later"
    end

    on_page "Finishing Up" do
      expect(page).to have_content("Before you finish, read and agree to the legal terms.")

      choose "I agree"

      proceed_with "Continue"
    end

    on_page "Finishing Up" do
      expect(page).to have_content("Enter your full legal name here to sign this application.")

      fill_in "Sign by typing your full legal name", with: "Jessie Tester"

      proceed_with "Sign and submit"
    end

    on_page "Application Submitted" do
      expect(page).to have_content(
        "Congratulations",
      )
    end
  end
end
