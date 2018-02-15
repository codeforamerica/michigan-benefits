require "rails_helper"
RSpec.feature "Anonymous caseworker sends a message to client" do
  scenario "sends successfully" do
    login_with_basic_caseworker_auth
    visit new_message_path
    expect(page).to have_text("Send client message")

    fill_in "Or enter a custom phone number", with: "2024561111"

    fill_in "Message", with: "Hey Alan! How ya doin?"

    click_on "Send"

    expect(FakeTwilioClient.messages.count).to eq 1
    latest_message = FakeTwilioClient.messages.last
    expect(latest_message.body).to eq("Hey Alan! How ya doin?")

    expect(page).to have_text "Your message to 2024561111 has been sent!"
    expect(page).to have_text("Send client message")
  end
end
