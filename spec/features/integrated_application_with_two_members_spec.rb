require "rails_helper"

RSpec.feature "Integrated application" do
  include PdfHelper

  scenario "with two members", :js do
    visit before_you_start_sections_path

    on_page "Introduction" do
      expect(page).to have_content("Welcome")

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
      expect(page).to have_content("Do you currently reside in Michigan?")

      proceed_with "Yes"
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
      expect(page).to have_content("Every family is different")

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

      proceed_with "Continue"
    end

    on_page "Your Household" do
      expect(page).to have_content(
        "Who do you currently live with?",
      )

      expect(page).to have_content("Jonny Tester")

      proceed_with "Continue"
    end

    on_page "Your Household" do
      expect(page).to have_content(
        "Who do you want to include on your Food Assistance application?",
      )

      # Jessie Tester checked by default
      check "Jonny Tester"

      proceed_with "Continue"
    end

    on_page "Your Household" do
      expect(page).to have_content(
        "Do you and Jonny share meals and food costs?",
      )

      proceed_with "No"
    end

    on_page "Application Submitted" do
      expect(page).to have_content(
        "Congratulations",
      )
    end

    emails = ActionMailer::Base.deliveries

    raw_application_pdf = emails.last.attachments.first.body.raw_source
    temp_file = write_raw_pdf_to_temp_file(source: raw_application_pdf)
    pdf_values = filled_in_values(temp_file.path)

    # Verify the PDF is not corrupt by testing minimal information
    expect(pdf_values["legal_name"]).to include("Jessie Tester")
    expect(pdf_values["anyone_buys_food_separately"]).to eq("Yes")
    expect(pdf_values["anyone_buys_food_separately_names"]).to include("Jonny Tester")
  end
end
