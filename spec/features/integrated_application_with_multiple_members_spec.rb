require "rails_helper"

RSpec.feature "Integrated application" do
  scenario "with multiple members", :js do
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
      expect(page).to have_content("Every family is different")

      click_on "Back"

      expect(page).to have_content("To start, please introduce yourself")

      proceed_with "Continue"
    end

    on_page "Introduction" do
      expect(page).to have_content("Every family is different")

      proceed_with "Continue"
    end
  end
end
