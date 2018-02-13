require "rails_helper"

RSpec.feature "Anonymous caseworker sends a message to client" do
  scenario "sends successfully", :js do
    visit new_message_path

    expect(page).to have_text("Send client message")

    select("Alan W. - 817-713-6264", from: "Client")

    fill_in "Message", with: "Hey Alan! How ya doin?"

    proceed_with "Send"

    expect(FakeTwilioClient.messages.count).to eq 1
    latest_message = FakeTwilioClient.messages.last
    expect(latest_message.body).to eq("Hey Alan! How ya doin?")

    expect(page).to have_text "Your message to 8177136264 has been sent!"
    expect(page).to have_text("Send client message")
  end
end
