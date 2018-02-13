require "rails_helper"

RSpec.feature "Anonymous caseworker sends a message to client" do
  scenario "sends successfully", :js do
    visit new_message_path

    expect(page).to have_text("Send client message")

    select('Alan W. - 817-713-6264', :from => 'Client')
  end
end
