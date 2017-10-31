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

    on_page "Introduction" do
      click_on "Add a member"
    end

    on_page "Introduction" do
      fill_in "What is their first name?", with: "Joel"
      fill_in "What is their last name?", with: "Tester"
      select_radio(question: "What is their gender?", answer: "Male")
      click_on "Next"
    end

    expect(page).to have_content("Jessie Tester")
    expect(page).to have_content("Christa Tester")
    expect(page).to have_content("Joel Tester")
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

    on_page "Introduction" do
      expect(page).to have_content(
        "Is anyone a caretaker or parent of other people in the household?",
      )
      click_on "Yes"
    end

    on_page "Introduction" do
      expect(page).to have_content(
        "Tell us who is a caretaker or parent of others in the household.",
      )
      check "Joel Tester"
      check "Jessie Tester"
      click_on "Next"
    end

    on_page "Health Coverage Needs" do
      expect(page).to have_content(
        "Who in your household needs healthcare coverage?",
      )
      uncheck "Jessie Tester"
      uncheck "Christa Tester"
      uncheck "Joel Tester"
      click_on "Next"
    end

    on_page "Health Coverage Needs" do
      expect(page).to have_content("Make sure you select at least one person")
      check "Jessie Tester"
      check "Christa Tester"
      uncheck "Joel Tester"
      click_on "Next"
    end

    on_pages "Health Coverage Needs" do
      expect(page).to have_content(
        "Is anyone currently enrolled in a health insurance plan?",
      )
      click_on "Yes"
    end

    on_page "Health Coverage Needs" do
      expect(page).to have_content(
        "Tell us who is currently enrolled in a health insurance plan.",
      )
      expect(page).to have_content("Jessie Tester")
      expect(page).to have_content("Christa Tester")
      expect(page).to have_content(
        "You've already indicated that Joel Tester is not in need of" \
        " additional health coverage.",
      )
      click_on "Next"

      expect(page).to have_content("Please select a member")
      check "Jessie Tester"
      click_on "Next"
    end

    on_page "Health Coverage Needs" do
      expect(page).to have_content(
        "Tell us what insurance plan each person is enrolled in.",
      )
      expect(page).not_to have_content("Joel Tester")
      expect(page).not_to have_content("Christa Tester")
      expect(page).to have_content("Jessie Tester")
      click_on "Next"

      expect(page).to have_content("Please select a plan")

      select_radio(question: "Jessie Tester", answer: "Medicaid")
      click_on "Next"
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
      click_on "Yes"
    end

    on_pages "Quick Health Questions" do
      expect(page).to have_content(
        "Does anyone in your household have a disability?",
      )
      click_on "Yes"

      expect(page).to have_content(
        "Who has a disability?",
      )
      check "Jessie Tester"
      click_on "Next"

      expect(page).to have_content("Has anyone been pregnant recently?")
      click_on "Yes"

      expect(page).to have_content("Tell us who has been pregnant recently.")
      check "Jessie Tester"
      click_on "Next"

      expect(page).to have_content(
        "Have you or someone in your household been affected "\
        "by the Flint Water Crisis",
      )
      click_on "Yes"

      expect(page).to have_content("We’ve noted this on your application.")
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

      expect(page).to have_content("Is anyone in the household self-employed?")
      click_on "Yes"

      expect(page).to have_content(
        "Tell us who in the household self-employed.",
      )
      check "Jessie Tester"
      click_on "Next"

      expect(page).to have_content(
        "Does anyone in the household get income that’s not from a job?",
      )
      click_on "Yes"

      expect(page).to have_content(
        "Tell us who gets income that’s not from a job.",
      )
      check "Jessie Tester"
      click_on "Next"

      expect(page).to have_content(
        "What type of income do you receive that’s not from a job?",
      )
      check "Unemployment"
      click_on "Next"
    end

    on_pages "Current Expenses" do
      expect(page).to have_content(
        "Does anyone in your household pay child support, alimony, or arrears?",
      )
      click_on "Yes"

      expect(page).to have_content(
        "Tell us who pays child support, alimony, or arrears.",
      )
      check "Jessie Tester"
      click_on "Next"

      expect(page).to have_content(
        "Does anyone in your household pay student loan interest?",
      )
      click_on "Yes"

      expect(page).to have_content(
        "Tell us who pays student loan interest.",
      )
      check "Jessie Tester"
      click_on "Next"
    end

    on_page "Income & Expense Amounts" do
      expect(page).to have_content(
        "Okay, thanks! Now describe your income and expenses.",
      )
    end
  end
end
