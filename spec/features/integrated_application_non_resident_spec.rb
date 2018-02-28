require "rails_helper"

RSpec.feature "Integrated application" do
  include PdfHelper

  scenario "where applicant is not a resident", :js do
    visit before_you_start_sections_path

    on_page "Introduction" do
      expect(page).to have_content("Welcome")

      proceed_with "Continue"
    end

    on_page "Introduction" do
      expect(page).to have_content("To start, please introduce yourself")

      fill_in "What's your first name?", with: "Jessie"
      fill_in "What's your last name?", with: "Tester"

      select "January", from: "form_birthday_2i"
      select "1", from: "form_birthday_3i"
      select "1969", from: "form_birthday_1i"

      select_radio(question: "What's your sex?", answer: "Female")

      proceed_with "Continue"
    end

    on_page "Introduction" do
      expect(page).to have_content("Do you currently reside in Michigan?")

      proceed_with "No"
    end

    on_page "Introduction" do
      expect(page).to have_content("Visit Healthcare.gov to apply for health coverage.")
    end
  end
end
