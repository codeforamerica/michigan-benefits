require "rails_helper"

RSpec.feature "Medicaid app" do
  scenario "with minimal info", :js do
    visit medicaid_root_path

    within(".slab--hero") do
      click_on "Apply for Medicaid"
    end

    on_pages "Introduction" do
      expect(page).to have_content("Welcome to the Medicaid application")
      click_on "Next"

      click_on "Yes"

      fill_in "What is your first name?", with: "Jessie"
      fill_in "What is your last name?", with: "Tester"
      select_radio(question: "What is your gender?", answer: "Female")
      click_on "Next"

      expect(page).to have_content(
        "Now tell us about any other people residing in your household.",
      )
      click_on "Next"

      expect(page).to have_content("Are you currently married?")
      click_on "No"

      expect(page).to have_content("Are you currently a college student?")
      click_on "No"

      expect(page).to have_content(
        "Are you currently a US citizen",
      )
      click_on "No"
    end

    on_pages "Health Coverage Needs" do
      expect(page).to have_content(
        "Next, describe your health coverage and status.",
      )
      click_on "Next"

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
        "Have you been affected by the Flint Water Crisis?",
      )
      click_on "No"
    end

    on_pages "Quick Tax Questions" do
      expect(page).to have_content(
        "Now describe how you file your taxes.",
      )
      click_on "Next"

      expect(page).to have_content(
        "Are you planning on filing taxes?",
      )
      click_on "No"

      expect(page).to have_content(
        "Are you claimed as a dependent on anyone else's taxes?",
      )

      click_on "No"
    end

    on_page "Income & Expenses" do
      expect(page).to have_content("Next, describe your income and expenses.")

      click_on "Next"
    end

    on_pages "Current Income" do
      expect(page).to have_content("Do you currently have a job?")
      click_on "No"

      expect(page).to have_content("Are you self-employed?")
      click_on "No"

      expect(page).to have_content("Do you get income that’s not from a job?")
      click_on "No"
    end

    on_pages "Current Expenses" do
      expect(page).to have_content(
        "Do you pay child support, alimony, or arrears?",
      )
      click_on "No"

      expect(page).to have_content("Do you pay student loan interest?")
      click_on "No"
    end

    on_pages "Contact Information & Followup" do
      expect(page).to have_content(
        "Now, let's get your contact and followup information.",
      )
      click_on "Next"

      expect(page).to have_content("Do you have stable housing right now?")
      click_on "No"

      expect(page).to have_content(
        "Is there a reliable place to send you mail?",
      )

      click_on "No"

      expect(page).to have_content(
        "What is the best number for you to receive phone calls?",
      )
      click_on "Next"

      expect(page).to have_content(
        "What is the best number for you to receive text messages?",
      )
      click_on "Next"

      expect(page).to have_content(
        "What is the best email address at which to contact you?",
      )
      click_on "Next"

      expect(page).to have_content(
        "Provide your Social Security Number and Date of Birth if you’re ready",
      )
      click_on "No"
    end

    on_page "Submit Paperwork & Sign" do
      expect(page).to have_content(
        "Lastly, we need to review your paperwork and get your signature.",
      )
      click_on "Next"
    end

    on_pages "Paperwork" do
      expect(page).to have_content(
        "Upload some paperwork if you can right now.",
      )
      click_on "I'll do this later"
    end

    on_page "Rights and Responsibilities" do
      expect(page).to have_content(
        "Before you finish, read and agree to the legal terms.",
      )
      choose "I agree"
      click_on "Next"
    end

    on_page "Sign and Submit" do
      fill_in "Sign by typing your full legal name", with: "Jessie Tester"
      click_on "Sign and submit"
    end

    on_pages "Application Submitted" do
      expect(page).to have_content(
        "Your application has been successfully submitted",
      )
    end
  end
end
