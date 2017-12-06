Slack.configure do |config|
  config.token = Rails.application.secrets.slack_api_token
end
