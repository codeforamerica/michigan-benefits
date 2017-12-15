require "rails_helper"

RSpec.feature "Submit application with minimal information" do
  scenario "completes successfully" do
    visit root_path
    within(".slab--hero") { click_on "Apply now" }

    on_page "Introduction" do
      expect(page).to have_content("Food Assistance Application")
      fill_in_name_and_birthday
      click_on "Continue"
    end

    fill_in "What is the best phone number to reach you?", with: "2222222222"
    click_on "Continue"

    fill_in "Address", with: "123 Main St"
    fill_in "City", with: "Flint"
    fill_in "ZIP code", with: "12345"
    select_address_same_as_home_address
    click_on "Continue"

    on_page "Introduction Complete" do
      click_on "Continue"
    end

    on_page "Introduction" do
      click_on "Continue"
    end

    select_radio(question: "What is your sex?", answer: "Female")
    select "Divorced", from: "What is your marital status?"
    click_on "Continue"

    on_page("Your Household") do
      click_on "Continue"
    end

    on_page("Your Household") do
      answer_household_more_info_questions(js: false)
      click_on "Continue"
    end

    on_page "Money & Income" do
      click_on "Continue"
    end

    on_page "Money & Income" do
      choose "No"
      click_on "Continue"
    end

    on_page "Money & Income" do
      select_employment(
        display_name: "Jessie Tester",
        employment_status: "Not Employed",
      )

      click_on "Continue"
    end

    on_page "Money & Income" do
      click_on "Continue"
    end

    on_page "Money & Income" do
      choose_no("Does your household have any money or accounts?")
      choose_no("Does your household own any property or real estate?")
      choose_no("Does your household own any vehicles?")

      click_on "Continue"
    end

    on_page "Expenses" do
      click_on "Continue"
    end

    on_page "Expenses" do
      click_on "Continue"
    end

    submit_expense_sources(answer: "no")

    on_page "Contact Preferences" do
      choose_no(
        "Would you like text message reminders about key steps and documents" +
        " required to help you through the enrollment process?",
      )
      click_on "Continue"
    end

    on_page "Other Details" do
      choose "No"
      click_on "Continue"
    end

    on_page "Other Details" do
      click_on "Continue"
    end

    on_page "Documents" do
      click_on "I'll do this later"
    end

    on_page "Rights and Responsibilities" do
      consent_to_terms
    end

    on_page "Sign and Submit" do
      fill_in "Sign by typing your full legal name", with: "Jessie Tester"
      click_on "Sign and submit"
    end

    on_page "Application Submitted" do
      click_on "Skip this step"
    end

    expect(page).to have_text(
      "Your application has been submitted.",
    )
  end
end
