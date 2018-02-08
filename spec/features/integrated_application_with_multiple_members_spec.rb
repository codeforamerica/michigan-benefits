require "rails_helper"

RSpec.feature "Integrated application" do
  scenario "with multiple members", :js do
    visit benefits_intro_sections_path

    on_page "Introduction" do
      expect(page).to have_content("Every family is different")
    end
  end
end
