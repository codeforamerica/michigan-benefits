require "rails_helper"

RSpec.feature "medicaid address flows" do
  scenario "client is homeless", :js do
    visit root_path

    within(".slab--hero") do
      proceed_with "Apply for Medicaid"
    end

    on_pages "Introduction" do
      expect(page).to have_content("Welcome to the Medicaid application")
      proceed_with "Next"

      proceed_with "Yes"
    end

    on_page "Office" do
      select_radio(
        question: "Which office are you in?",
        answer: "I'm not in an office",
      )
      proceed_with "Next"
    end

    on_page "Introduction" do
      fill_in "What is your first name?", with: "Jessie"
      fill_in "What is your last name?", with: "Tester"
      select_radio(question: "What is your gender?", answer: "Female")
      proceed_with "Next"
    end

    visit "steps/medicaid/contact"
    expect(page).to have_content("Do you have stable housing right now?")
    proceed_with "No"

    expect(page).to have_content(
      "Is there a reliable place to send you mail?",
    )
    proceed_with "No"

    expect(page).to have_content(
      "What is the best number for you to receive phone calls?",
    )
  end

  scenario "client does not have stable housing", :js do
    visit root_path

    within(".slab--hero") do
      proceed_with "Apply for Medicaid"
    end

    on_pages "Introduction" do
      expect(page).to have_content("Welcome to the Medicaid application")
      proceed_with "Next"

      proceed_with "Yes"
    end

    on_page "Office" do
      select_radio(
        question: "Which office are you in?",
        answer: "I'm not in an office",
      )
      proceed_with "Next"
    end

    on_page "Introduction" do
      fill_in "What is your first name?", with: "Jessie"
      fill_in "What is your last name?", with: "Tester"
      select_radio(question: "What is your gender?", answer: "Female")
      proceed_with "Next"
    end

    visit "steps/medicaid/contact"
    expect(page).to have_content("Do you have stable housing right now?")
    proceed_with "No"

    expect(page).to have_content(
      "Is there a reliable place to send you mail?",
    )
    proceed_with "Yes"

    expect(page).to have_content(
      "What is your mailing address?",
    )

    fill_in "Street address", with: "123 Some St."
    fill_in "City", with: "Flint"
    fill_in "ZIP code", with: "48501"

    proceed_with "Next"

    expect(page).to have_content(
      "What is the best number for you to receive phone calls?",
    )
  end

  scenario "client has same home and mailing addresses", :js do
    visit root_path

    within(".slab--hero") do
      proceed_with "Apply for Medicaid"
    end

    on_pages "Introduction" do
      expect(page).to have_content("Welcome to the Medicaid application")
      proceed_with "Next"

      proceed_with "Yes"
    end

    on_page "Office" do
      select_radio(
        question: "Which office are you in?",
        answer: "I'm not in an office",
      )
      proceed_with "Next"
    end

    on_page "Introduction" do
      fill_in "What is your first name?", with: "Jessie"
      fill_in "What is your last name?", with: "Tester"
      select_radio(question: "What is your gender?", answer: "Female")
      proceed_with "Next"
    end

    visit "steps/medicaid/contact"
    expect(page).to have_content("Do you have stable housing right now?")
    proceed_with "Yes"

    expect(page).to have_content("What is your home address?")

    fill_in "Street address", with: "123 Some St."
    fill_in "City", with: "Flint"
    fill_in "ZIP code", with: "48501"

    proceed_with "Next"

    expect(page).to have_content(
      "What is the best number for you to receive phone calls?",
    )
  end
end
