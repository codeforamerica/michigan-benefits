require "rails_helper"

RSpec.feature "Medicaid app" do
  scenario "with a single member", :js do
    visit medicaid_root_path

    within(".slab--hero") do
      click_on "Apply for Medicaid"
    end

    on_pages "Introduction" do
      click_on "Yes"

      fill_in "What is your first name?", with: "Jessie"
      fill_in "What is your last name?", with: "Tester"
      select_radio(question: "What is your gender?", answer: "Female")
      click_on "Next"

      expect(page).to have_content(
        "Now tell us about any other people residing in your household.",
      )
      click_on "Next"

      expect(page).to have_content("Are you currently a college student?")
      click_on "No"

      expect(page).to have_content("Are you currently a US Citizen?")
      click_on "Yes"
    end

    on_pages "Health Coverage Needs" do
      expect(page).to have_content(
        "Are you currently enrolled in a health insurance plan?",
      )
      click_on "No"

      expect(page).to have_content(
        "Do you need help paying for medical expenses from the last 3 months?",
      )
      click_on "Yes"
    end

    on_pages "Quick Health Questions" do
      expect(page).to have_content("Do you have a disability?")
      click_on "No"

      expect(page).to have_content("Have you been pregnant recently?")
      click_on "No"
    end

    on_pages "Quick Tax Question" do
      expect(page).to have_content(
        "Do you plan on filing a federal tax return next year?",
      )

      click_on "Yes"
    end

    on_pages "Current Income" do
      expect(page).to have_content("Do you currently have a job?")
      click_on "Yes"

      expect(page).to have_content("Tell us how many jobs you currently have.")
      choose "3 jobs"
      click_on "Next"

      expect(page).to have_content("Are you self-employed?")
      click_on "No"

      expect(page).to have_content("Do you get income that's not from a job?")
      click_on "Yes"

      expect(page).to have_content(
        "What type of income do you receive that’s not from a job?",
      )
      check "Unemployment"
      click_on "Next"
    end

    on_pages "Current Expenses" do
      expect(page).to have_content(
        "Do you pay child support, alimony or arrears?",
      )
      click_on "No"

      expect(page).to have_content("Do you pay student loan interest?")
      click_on "No"
    end

    on_pages "Income & Expense Amounts" do
      click_on "Next"

      fill_in "Your Current Job (#1)", with: 100
      fill_in "Your Current Job (#2)", with: 50
      fill_in "Your Current Job (#3)", with: 25
      fill_in "Your Unemployment", with: 100
      click_on "Next"
    end

    find(".icon-arrow_back").click

    on_pages "Income & Expense Amounts" do
      expect(find("#step_employed_monthly_income_0").value).to eq "100"
      expect(find("#step_employed_monthly_income_1").value).to eq "50"
      expect(find("#step_employed_monthly_income_2").value).to eq "25"
      click_on "Next"
    end

    on_pages "Contact Information & Followup" do
      expect(page).to have_content(
        "Do you receive mail at your current residential address?",
      )
      click_on "Yes"

      fill_in "Street address", with: "123 Some St."
      fill_in "City", with: "Flint"
      fill_in "ZIP code", with: "48501"
      click_on "Next"

      fill_in "Phone number", with: "8005550000"
      click_on "Next"

      expect(page).to have_content(
        "What is the best number for you to receive text messages?",
      )
      click_on "Next"

      fill_in "Email address", with: "jo@example.com"
      click_on "Next"

      expect(page).to have_content(
        "Provide your Social Security Number and Date of Birth if you're ready",
      )
      click_on "Yes"

      fill_in "Social Security Number", with: "000992222"
      fill_in_birthday
      click_on "Next"
    end

    on_page "Confirmation" do
      click_on "No"
    end

    expect(page).to have_content("Get the support your family needs")
  end

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
      expect(page).to have_content("Are you currently a college student?")
      click_on "No"
    end

    on_page "Introduction" do
      expect(page).to have_content("Are you currently a US Citizen?")
      click_on "Yes"
    end

    on_page "Health Coverage Needs" do
      expect(page).to have_content(
        "Who in your household needs healthcare coverage?
",
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
