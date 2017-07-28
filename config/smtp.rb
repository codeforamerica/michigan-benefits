SMTP_SETTINGS = {
  port: ENV["MAILGUN_SMTP_PORT"],
  address: ENV["MAILGUN_SMTP_SERVER"],
  user_name: ENV["MAILGUN_SMTP_LOGIN"],
  password: ENV["MAILGUN_SMTP_PASSWORD"],
  authentication: :plain,
}.freeze
