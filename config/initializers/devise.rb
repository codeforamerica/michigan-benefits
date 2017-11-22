Devise.setup do |config|
  config.mailer_sender = "hello@michiganbenefits.org"
  require "devise/orm/active_record"

  config.case_insensitive_keys = [:email]
  config.strip_whitespace_keys = [:email]
  config.skip_session_storage = [:http_auth]
  config.stretches = Rails.env.test? ? 1 : 11
  config.reconfirmable = true
  config.expire_all_remember_me_on_sign_out = true
  config.password_length = 6..128
  config.email_regexp = /\A[^@\s]+@[^@\s]+\z/
  config.reset_password_within = 6.hours
  config.sign_out_via = :delete

  # ==> Devise OTP Extension
  # Configure OTP extension for devise

  # OTP is mandatory, users are going to be asked to
  # enroll OTP the next time they sign in, before they can successfully complete the session establishment.
  # This is the global value, can also be set on each user.
  config.otp_mandatory = !Rails.env.test?

  # Drift: a window which provides allowance for drift between a user's token device clock
  # (and therefore their OTP tokens) and the authentication server's clock.
  # Expressed in minutes centered at the current time. (Note: it's a number, *NOT* 3.minutes )
  # config.otp_drift_window = 3

  # Users that have logged in longer than this time ago, are going to be asked their password
  # (and an OTP challenge, if enabled) before they can see or change their otp informations.
  # config.otp_credentials_refresh = 15.minutes

  # Users are given a list of one-time recovery tokens, for emergency access
  # set to false to disable giving recovery tokens.
  # config.otp_recovery_tokens = 10

  # The user is allowed to set his browser as "trusted", no more OTP challenges will be
  # asked for that browser, for a limited time.
  # set to false to disable setting the browser as trusted
  # config.otp_trust_persistence = 1.month

  # The name of the token issuer, to be added to the provisioning
  # url. Display will vary based on token application. (defaults to the Rails application class)
  otp_env = Rails.env.production? ? "" : " - #{Rails.env}"
  config.otp_issuer = "MichiganBenefits.org" + otp_env
end
