require "rails_helper"

RSpec.feature "Medicaid app" do
  scenario "with multiple members", :js do
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

      proceed_with "No"

      click_on "Add a member"

      fill_in "What is their first name?", with: "Christa"
      fill_in "What is their last name?", with: "Tester"
      select_radio(question: "What is their gender?", answer: "Female")
      select "December"
      select "25"
      select "1987"
      proceed_with "Next"

      click_on "Add a member"

      fill_in "What is their first name?", with: "Joel"
      fill_in "What is their last name?", with: "Tester"
      select_radio(question: "What is their gender?", answer: "Male")
      select "September"
      select "17"
      select "1980"
      proceed_with "Next"
    end

    expect(page).to have_content("Jessie Tester")
    expect(page).to have_content("Christa Tester")
    expect(page).to have_content("Joel Tester")
    proceed_with "Next"

    on_page "Introduction" do
      expect(page).to have_content(
        "Is anyone in your household currently married?",
      )
      proceed_with "Yes"
    end

    on_page "Introduction" do
      expect(page).to have_content(
        t("medicaid.intro_marital_status_member.edit.title"),
      )
      check "Jessie Tester"
      check "Christa Tester"
      check "Joel Tester"
      proceed_with "Next"
    end

    on_page "Introduction" do
      expect(page).to have_content(
        "Tell us who Jessie Tester is currently married to",
      )
      choose "Christa Tester"
      proceed_with "Next"
    end

    on_page "Introduction" do
      expect(page).to have_content(
        "Tell us who Joel Tester is currently married to",
      )
      choose "Other - not listed"
      proceed_with "Next"
    end

    on_page "Introduction" do
      expect(page).to have_content("Is anyone currently a college student?")
      proceed_with "Yes"
    end

    on_page "Introduction" do
      expect(page).to have_content(
        t("medicaid.intro_college_member.edit.title"),
      )
      check "Jessie Tester"
      proceed_with "Next"
    end

    on_page "Introduction" do
      expect(page).to have_content(
        "Is everyone in your household currently a US citizen",
      )
      proceed_with "No"
    end

    on_page "Introduction" do
      expect(page).to have_content(
        t("medicaid.intro_citizen_member.edit.title"),
      )
      check "Jessie Tester"
      proceed_with "Next"
    end

    on_page "Introduction" do
      expect(page).to have_content(
        "Is anyone a caretaker or parent of other people in the household?",
      )
      proceed_with "Yes"
    end

    on_page "Introduction" do
      expect(page).to have_content(
        t("medicaid.intro_caretaker_member.edit.title"),
      )
      check "Joel Tester"
      check "Jessie Tester"
      proceed_with "Next"
    end

    on_page "Health Coverage Needs" do
      expect(page).to have_content(
        "Next, describe your health coverage and status.",
      )

      proceed_with "Next"
      expect(page).to have_content(
        t("medicaid.insurance_needed.edit.title"),
      )
      uncheck "Jessie Tester"
      uncheck "Christa Tester"
      uncheck "Joel Tester"
      proceed_with "Next"
    end

    on_page "Health Coverage Needs" do
      expect(page).to have_content("Make sure you select at least one person")
      check "Jessie Tester"
      check "Christa Tester"
      uncheck "Joel Tester"
      proceed_with "Next"
    end

    on_pages "Health Coverage Needs" do
      expect(page).to have_content(
        "Is anyone currently enrolled in a health insurance plan?",
      )
      proceed_with "Yes"
    end

    on_page "Health Coverage Needs" do
      expect(page).to have_content(
        I18n.t("medicaid.insurance_current_member.edit.title"),
      )
      expect(page).to have_content("Jessie Tester")
      expect(page).to have_content("Christa Tester")
      expect(page).to have_content(
        "You've already indicated that Joel Tester is not in need of" \
        " additional health coverage.",
      )
      proceed_with "Next"

      expect(page).to have_content("Make sure you select a person")
      check "Jessie Tester"
      proceed_with "Next"
    end

    on_page "Health Coverage Needs" do
      expect(page).to have_content(
        "What type of insurance plan is Jessie Tester currently enrolled in",
      )
      choose("Medicaid")
      proceed_with "Next"
    end

    on_page "Health Coverage Needs" do
      expect(page).to have_content(
        "Do you need help paying for medical expenses from the last 3 months?",
      )
    end

    on_pages "Health Coverage Needs" do
      expect(page).to have_content(
        "Do you need help paying for medical expenses from the last 3 months?",
      )
      proceed_with "Yes"
    end

    on_pages "Quick Health Questions" do
      expect(page).to have_content(
        "Does anyone in your household have a disability?",
      )
      proceed_with "Yes"

      expect(page).to have_content(
        t("medicaid.health_disability_member.edit.title"),
      )
      check "Jessie Tester"
      proceed_with "Next"

      expect(page).to have_content(
        "Has anyone been pregnant recently?",
      )
      proceed_with "Yes"

      expect(page).to have_content(
        t("medicaid.health_pregnancy_member.edit.title"),
      )
      check "Jessie Tester"
      proceed_with "Next"

      expect(page).to have_content(
        "Have you or someone in your household been affected "\
        "by the Flint Water Crisis",
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

      expect(page).to have_content(
        "Do you plan on filing taxes with any family members "\
        "in your household?",
      )

      proceed_with "Yes"

      expect(page).to have_content(
        t("medicaid.tax_filing_with_household_members_member.edit.title"),
      )
      check "Joel Tester"
      proceed_with "Next"

      expect(page).to have_content(
        I18n.t(
          "medicaid.tax_filing_with_household_members_relationship.edit.title",
        ),
      )

      proceed_with "Next"
      expect(page).to have_content("Make sure you select one option")

      select "Joint"
      proceed_with "Next"

      expect(page).to have_content("Great! Let's review your tax info:")
      expect(page).to have_content("Joel Tester - Joint")
      proceed_with "Next"
    end

    on_page "Income & Expenses" do
      expect(page).to have_content("Next, describe your income and expenses.")

      proceed_with "Next"
    end

    on_pages "Current Income" do
      expect(page).to have_content(
        "Does anyone in your household currently have a job?",
      )
      proceed_with "Yes"

      expect(page).to have_content(
        "Tell us who in your household has one or more jobs.",
      )
      select_job_number(display_name: "Christa Tester", job_number: "2 jobs")
      proceed_with "Next"

      expect(page).to have_content("Is anyone in the household self-employed?")
      proceed_with "Yes"

      expect(page).to have_content(
        t("medicaid.income_self_employment_member.edit.title"),
      )
      check "Jessie Tester"
      proceed_with "Next"

      expect(page).to have_content(
        "Does anyone in the household get income that’s not from a job?",
      )
      proceed_with "Yes"

      expect(page).to have_content(
        t("medicaid.income_other_income_member.edit.title"),
      )
      check "Jessie Tester"
      check "Christa Tester"
      proceed_with "Next"

      expect(page).to have_content(
        "What type of income does Jessie Tester receive that’s not from a job?",
      )
      check "Unemployment"
      proceed_with "Next"

      expect(page).to have_content(
        "What type of income does Christa Tester receive that’s not from a" +
        " job?",
      )
      check "Other"
      proceed_with "Next"
    end

    on_pages "Current Expenses" do
      expect(page).to have_content(
        "Does anyone in your household pay child support, alimony, or arrears?",
      )
      proceed_with "Yes"

      expect(page).to have_content(
        t("medicaid.expenses_alimony_member.edit.title"),
      )
      check "Jessie Tester"
      check "Christa Tester"
      proceed_with "Next"

      expect(page).to have_content(
        "Does anyone in your household pay student loan interest?",
      )
      proceed_with "Yes"

      expect(page).to have_content(
        t("medicaid.expenses_student_loan_member.edit.title"),
      )
      check "Jessie Tester"
      proceed_with "Next"
    end

    on_page "Income & Expense Amounts" do
      expect(page).to have_content("You're almost done!")
      proceed_with "Next"
    end

    on_page "Income & Expense Amounts" do
      expect(page).to have_content(
        "Tell us Jessie Tester’s specific income received",
      )
      fill_in "step_self_employed_monthly_income", with: 100
      fill_in "step_unemployment_income", with: 100
      proceed_with "Next"
    end

    on_page "Income & Expense Amounts" do
      expect(page).to have_content(
        "Tell us Christa Tester’s specific income received",
      )

      within(find("fieldset", text: "Job #1")) do
        fill_in "Employer name", with: "CfA"
        fill_in "Average amount / paycheck", with: 100
        select "Monthly", from: "How often are you paid that amount?"
      end

      within(find("fieldset", text: "Job #2")) do
        fill_in "Employer name", with: "Cylinder"
        fill_in "Average amount / paycheck", with: 100
        select "Monthly", from: "How often are you paid that amount?"
      end

      proceed_with "Next"

      expect(page).to have_content("Tell us Jessie Tester’s specific expenses")
      fill_in(
        "step_child_support_alimony_arrears_expenses",
        with: "100",
      )
      fill_in "step_self_employed_monthly_expenses", with: "100"
      proceed_with "Next"

      expect(page).to have_content("Tell us Christa Tester’s specific expenses")

      fill_in(
        "step_child_support_alimony_arrears_expenses",
        with: "100",
      )
      proceed_with "Next"
    end

    on_page "Contact Information & Followup" do
      expect(page).to have_content(
        "Now, let's get your contact and followup information.",
      )
      proceed_with "Next"

      expect(page).to have_content(
        "Do you have stable housing right now?",
      )
      proceed_with "No"
    end

    on_page "Contact Information & Followup" do
      expect(page).to have_content(
        "Is there a reliable place to send you mail?",
      )
      proceed_with "No"
    end

    on_page "Contact Information & Followup" do
      expect(page).to have_content(
        "What is the best number for you to receive phone calls?",
      )
      fill_in "Phone number", with: "2024561111"
      proceed_with "Next"
    end

    on_page "Contact Information & Followup" do
      expect(page).to have_content(
        "What is the best number for you to receive text messages?",
      )
      proceed_with "Next"
    end

    on_page "Contact Information & Followup" do
      expect(page).to have_content(
        "What is the best email address at which to contact you?",
      )
      proceed_with "Next"
    end

    on_page "Contact Information & Followup" do
      expect(page).to have_content(
        "Provide the Social Security Numbers "\
        "for your household members if you’re ready",
      )
      proceed_with "Yes"
    end

    on_page "Contact Information & Followup" do
      expect(page).to have_content(
        "Tell us your Social Security Number",
      )
      enter_ssn(display_name: "Jessie Tester", ssn: "123456789")
      enter_ssn(display_name: "Christa Tester", ssn: "011100000")

      proceed_with "Next"
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
      proceed_with "I'll do this later"
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
