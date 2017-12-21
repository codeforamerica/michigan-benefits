require "rails_helper"

RSpec.feature "Medicaid app" do
  scenario "with maximum info", :js do
    visit medicaid_root_path

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
      proceed_with "Yes"

      expect(page).to have_content("Are you currently a college student?")
      proceed_with "Yes"

      expect(page).to have_content("Are you currently a US citizen?")
      proceed_with "Yes"
    end

    on_pages "Health Coverage Needs" do
      expect(page).to have_content(
        "Next, describe your health coverage and status.",
      )
      proceed_with "Next"

      expect(page).to have_content(
        "Are you currently enrolled in a health insurance plan?",
      )
      proceed_with "Yes"

      expect(page).to have_content(
        "What type of insurance plan is Jessie Tester currently enrolled in?",
      )
      choose "Other"
      proceed_with "Next"

      expect(page).to have_content(
        "Do you need help paying for medical expenses from the last 3 months?",
      )
      proceed_with "Yes"
    end

    on_pages "Quick Health Questions" do
      expect(page).to have_content("Do you have a disability?")
      proceed_with "Yes"

      expect(page).to have_content("Have you been pregnant recently?")
      proceed_with "Yes"

      expect(page).to have_content(
        "Have you been affected by the Flint Water Crisis?",
      )
      proceed_with "Yes"

      expect(page).to have_content("We’ve noted this on your application.")
      proceed_with "Next"
    end

    on_pages "Quick Tax Questions" do
      expect(page).to have_content(
        "Now describe how you file your taxes.",
      )
      proceed_with "Next"

      expect(page).to have_content(
        "Are you planning on filing taxes?",
      )

      proceed_with "Yes"
    end

    on_page "Income & Expenses" do
      expect(page).to have_content("Next, describe your income and expenses.")

      proceed_with "Next"
    end

    on_pages "Current Income" do
      expect(page).to have_content("Do you currently have a job?")
      proceed_with "Yes"

      expect(page).to have_content("Tell us how many jobs you currently have.")
      choose "3 jobs"
      proceed_with "Next"

      expect(page).to have_content("Are you self-employed?")
      proceed_with "Yes"

      expect(page).to have_content("Do you get income that’s not from a job?")
      proceed_with "Yes"

      expect(page).to have_content(
        "What type of income do you receive that’s not from a job?",
      )
      check "Unemployment"
      proceed_with "Next"
    end

    on_pages "Current Expenses" do
      expect(page).to have_content(
        "Do you pay child support, alimony, or arrears?",
      )
      proceed_with "Yes"

      expect(page).to have_content("Do you pay student loan interest?")
      proceed_with "Yes"
    end

    on_pages "Income & Expense Amounts" do
      proceed_with "Next"

      within(find("fieldset", text: "Job #1")) do
        fill_in "Employer name", with: "CfA"
        fill_in "Average amount / paycheck", with: 100
        select "Weekly", from: "How often are you paid that amount?"
      end

      within(find("fieldset", text: "Job #2")) do
        fill_in "Employer name", with: "Cylinder"
        fill_in "Average amount / paycheck", with: 25
        select "Hourly", from: "How often are you paid that amount?"
      end

      within(find("fieldset", text: "Job #3")) do
        fill_in "Employer name", with: "Acme Co."
        fill_in "Average amount / paycheck", with: 50
        select "Monthly", from: "How often are you paid that amount?"
      end

      fill_in "step_self_employed_monthly_income", with: 100
      fill_in "step_unemployment_income", with: 100
      proceed_with "Next"

      expect(page).to have_content("Tell us your specific expenses.")
      fill_in "step_child_support_alimony_arrears_expenses", with: 100
      fill_in "step_student_loan_interest_expenses", with: 50
      fill_in "step_self_employed_monthly_expenses", with: 50
      proceed_with "Next"
    end

    on_pages "Contact Information & Followup" do
      expect(page).to have_content(
        "Now, let's get your contact and followup information.",
      )
      proceed_with "Next"

      expect(page).to have_content(
        "Do you have stable housing right now?",
      )
      proceed_with "Yes"

      expect(page).to have_content("What is your home address?")
      fill_in "Street address", with: "123 Some St."
      fill_in "Street address 2", with: "Apt B"
      fill_in "City", with: "Flint"
      fill_in "ZIP code", with: "48501"

      uncheck "This is the same as my mailing address"

      proceed_with "Next"

      expect(page).to have_content("What is your mailing address?")
      fill_in "Street address", with: "123 Some St."
      fill_in "Street address 2", with: "Apt B"
      fill_in "City", with: "Flint"
      fill_in "ZIP code", with: "48501"

      proceed_with "Next"

      expect(page).to have_content(
        "What is the best number for you to receive phone calls?",
      )
      fill_in "Phone number", with: "8005550000"
      proceed_with "Next"

      expect(page).to have_content(
        "What is the best number for you to receive text messages?",
      )
      proceed_with "Next"

      fill_in "Email address", with: "jo@example.com"
      proceed_with "Next"

      expect(page).to have_content(
        "Provide your Social Security Number and Date of Birth if you’re ready",
      )
      proceed_with "Yes"

      fill_in "Social Security Number", with: "999900000"
      select "September"
      select "17"
      select "1980"
      proceed_with "Next"
    end

    on_page "Submit Paperwork & Sign" do
      expect(page).to have_content(
        "Lastly, we need to get your signature and review your paperwork.",
      )
      proceed_with "Next"
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

    on_pages "Documents" do
      expect(page).to have_content(
        "Upload some paperwork if you can right now.",
      )
      proceed_with "I'll do this later", scroll_to_top: true
    end

    on_pages "Application Submitted" do
      expect(page).to have_content(
        "Your application has been successfully submitted",
      )
    end
  end
end
