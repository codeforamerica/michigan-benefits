require "rails_helper"

RSpec.feature "medicaid address flows" do
  scenario "client is homeless", :js do
    visit medicaid_root_path

    within(".slab--hero") do
      click_on "Apply for Medicaid"
    end

    on_pages "Introduction" do
      expect(page).to have_content("Medicaid Application")

      click_on "Yes"

      fill_in "What is your first name?", with: "Jessie"
      fill_in "What is your last name?", with: "Tester"
      select_radio(question: "What is your gender?", answer: "Female")
      click_on "Next"
    end

    visit "steps/medicaid/contact"
    expect(page).to have_content("Do you have stable housing right now?")
    click_on "No"

    expect(page).to have_content(
      "Is there a reliable place to send you mail?",
    )
    click_on "No"

    expect(page).to have_content(
      "What is the best number for you to receive phone calls?",
    )
  end

  scenario "client does not have stable housing", :js do
    visit medicaid_root_path

    within(".slab--hero") do
      click_on "Apply for Medicaid"
    end

    on_pages "Introduction" do
      expect(page).to have_content("Medicaid Application")

      click_on "Yes"

      fill_in "What is your first name?", with: "Jessie"
      fill_in "What is your last name?", with: "Tester"
      select_radio(question: "What is your gender?", answer: "Female")
      click_on "Next"
    end

    visit "steps/medicaid/contact"
    expect(page).to have_content("Do you have stable housing right now?")
    click_on "No"

    expect(page).to have_content(
      "Is there a reliable place to send you mail?",
    )
    click_on "Yes"

    expect(page).to have_content(
      "What is your mailing address?",
    )

    fill_in "Street address", with: "123 Some St."
    fill_in "City", with: "Flint"
    fill_in "ZIP code", with: "48501"

    click_on "Next"

    expect(page).to have_content(
      "What is the best number for you to receive phone calls?",
    )
  end
end
