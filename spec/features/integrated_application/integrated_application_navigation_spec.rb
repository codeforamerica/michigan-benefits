require "rails_helper"

RSpec.feature "Integrated application" do
  scenario "form navigation", :js do
    visit sections_path

    expect(page).to have_content("Navigation")
  end
end
