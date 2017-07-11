if Rails.env.development? or Rails.env.test?
  require File.expand_path("#{Rails.root}/spec/support/fake_twilio_client")
  silence_warnings do
    Twilio::REST::Client = FakeTwilioClient
  end
elsif Rails.env.production?
  Twilio.configure do |config|
    config.account_sid = ENV["TWILIO_ACCOUNT_SID"]
    config.auth_token = ENV["TWILIO_AUTH_TOKEN"]
  end
end
