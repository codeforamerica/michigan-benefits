class SmsMessageJob < ApplicationJob
  def perform(message:)
    twilio_client = Twilio::REST::Client.new
    twilio_client.messages.create(
      to: message.phone,
      from: Rails.application.secrets.twilio_phone_number,
      body: message.body,
      media_url: message.screenshots,
    )
  end
end
