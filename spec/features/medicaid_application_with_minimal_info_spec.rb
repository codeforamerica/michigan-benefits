require "rails_helper"

RSpec.feature "Medicaid app" do
  scenario "with minimal info", :js do
    visit root_path

    within(".slab--hero") do
      proceed_with "Apply for Medicaid"
    end

    on_pages "Introduction" do
      expect(page).to have_content("Welcome to the Medicaid application")
      proceed_with "Next"

      proceed_with "Yes"

      fill_in "What is your first name?", with: "Jessie"
      fill_in "What is your last name?", with: "Tester"
      select_radio(question: "What is your gender?", answer: "Female")
      proceed_with "Next"

      expect(page).to have_content(
        "Now tell us about any other people residing in your household.",
      )
      proceed_with "Next"

      expect(page).to have_content("Are you currently married?")
      proceed_with "No"

      expect(page).to have_content("Are you currently a college student?")
      proceed_with "No"

      expect(page).to have_content(
        "Are you currently a US citizen",
      )
      proceed_with "No"
    end

    on_pages "Health Coverage Needs" do
      expect(page).to have_content(
        "Next, describe your health coverage and status.",
      )
      proceed_with "Next"

      expect(page).to have_content(
        "Are you currently enrolled in a health insurance plan?",
      )
      proceed_with "No"

      expect(page).to have_content(
        "Do you need help paying for medical expenses from the last 3 months?",
      )
      proceed_with "No"
    end

    on_pages "Quick Health Questions" do
      expect(page).to have_content("Do you have a disability?")
      proceed_with "No"

      expect(page).to have_content("Have you been pregnant recently?")
      proceed_with "No"

      expect(page).to have_content(
        "Have you been affected by the Flint Water Crisis?",
      )
      proceed_with "No"
    end

    on_pages "Quick Tax Questions" do
      expect(page).to have_content(
        "Now describe how you file your taxes.",
      )
      proceed_with "Next"

      expect(page).to have_content(
        "Are you planning on filing taxes?",
      )
      proceed_with "No"

      expect(page).to have_content(
        "Are you claimed as a dependent on anyone else's taxes?",
      )

      proceed_with "No"
    end

    on_page "Income & Expenses" do
      expect(page).to have_content("Next, describe your income and expenses.")

      proceed_with "Next"
    end

    on_pages "Current Income" do
      expect(page).to have_content("Do you currently have a job?")
      proceed_with "No"

      expect(page).to have_content("Are you self-employed?")
      proceed_with "No"

      expect(page).to have_content("Do you get income that’s not from a job?")
      proceed_with "No"
    end

    on_pages "Current Expenses" do
      expect(page).to have_content(
        "Do you pay child support, alimony, or arrears?",
      )
      proceed_with "No"

      expect(page).to have_content("Do you pay student loan interest?")
      proceed_with "No"
    end

    on_pages "Contact Information & Followup" do
      expect(page).to have_content(
        "Now, let's get your contact and followup information.",
      )
      proceed_with "Next"

      expect(page).to have_content("Do you have stable housing right now?")
      proceed_with "No"

      expect(page).to have_content(
        "Is there a reliable place to send you mail?",
      )

      proceed_with "No"

      expect(page).to have_content(
        "What is the best number for you to receive phone calls?",
      )
      proceed_with "Next"

      expect(page).to have_content(
        "What is the best number for you to receive text messages?",
      )
      proceed_with "Next"

      expect(page).to have_content(
        "What is the best email address at which to contact you?",
      )
      proceed_with "Next"

      expect(page).to have_content(
        "Provide your Social Security Number if you’re ready",
      )
      proceed_with "No"
    end

    on_page "Submit Paperwork & Sign" do
      expect(page).to have_content(
        "Lastly, we need to get your signature and review your paperwork.",
      )
      proceed_with "Next"
    end

    on_pages "Paperwork" do
      expect(page).to have_content(
        "Do you have paperwork with you?",
      )
      proceed_with "I'll do this later", scroll_to_top: true
    end

    on_page "Rights and Responsibilities" do
      expect(page).to have_content(
        "Before you finish, read and agree to the legal terms.",
      )
      choose "I agree"
      proceed_with "Next"
    end

    on_page "Sign and Submit" do
      fill_in "Sign by typing your full legal name", with: "Jessie Tester"
      proceed_with "Sign and submit"
    end

    on_pages "Application Submitted" do
      expect(page).to have_content(
        "Your application has been successfully submitted",
      )
    end
  end
end
