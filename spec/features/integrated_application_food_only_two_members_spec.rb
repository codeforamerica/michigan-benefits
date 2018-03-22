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

    on_page "Review" do
      expect(page).to have_content(
        "Here's who's applying for Food Assistance with you:",
      )

      within "#applying-with-you" do
        expect(page).to have_content("Jessie Tester (that's you!)")
      end

      within "#not-applying-with-you" do
        expect(page).to have_content("Jonny Tester")
      end

      proceed_with "Continue"
    end

    on_page "Healthcare" do
      expect(page).to have_content(
        "Which people also need Healthcare Coverage?",
      )

      uncheck "Jessie Tester"
      uncheck "Jonny Tester"

      proceed_with "Continue"
    end

    on_page "Healthcare" do
      expect(page).to have_content(
        "Are you sure you don't want to apply for Healthcare Coverage?",
      )

      proceed_with "Yes, I'm sure"
    end

    expect(current_path).to eq(root_path)
  end
end
