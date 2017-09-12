# frozen_string_literal: true

if Rails.env.development? || Rails.env.test?
  require File.expand_path("#{Rails.root}/spec/support/fake_twilio_client")
  silence_warnings do
    Twilio::REST::Client = FakeTwilioClient
  end
elsif Rails.env.production?
  Twilio.configure do |config|
    config.account_sid = Rails.application.secrets.twilio_account_sid
    config.auth_token = Rails.application.secrets.twilio_auth_token
  end
end
