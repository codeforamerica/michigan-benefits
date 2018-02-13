require "rails_helper"

RSpec.feature "Anonymous caseworker sends a message to client" do
  scenario "sends successfully", :js do
    visit new_casenote_path

    expect(page).to have_text("Send client message")
  end
end
