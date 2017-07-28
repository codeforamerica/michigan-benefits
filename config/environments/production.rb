# frozen_string_literal: true

require Rails.root.join("config/smtp")

Rails.application.configure do
  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true
  config.public_file_server.enabled = ENV["RAILS_SERVE_STATIC_FILES"].present?
  config.assets.js_compressor = :uglifier
  config.assets.compile = false
  config.log_level = :debug
  config.log_tags = [:request_id]
  config.action_mailer.perform_caching = false

  # Customize default host
  config.action_mailer.default_url_options = {
    host: ENV["HOSTNAME_FOR_URLS"],
    protocol: "http",
  }

  config.action_mailer.smtp_settings = SMTP_SETTINGS
  config.action_mailer.delivery_method = :smtp

  config.i18n.fallbacks = true
  config.active_support.deprecation = :notify
  config.log_formatter = ::Logger::Formatter.new

  if ENV["RAILS_LOG_TO_STDOUT"].present?
    logger           = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger = ActiveSupport::TaggedLogging.new(logger)
  end

  config.active_record.dump_schema_after_migration = false

  config.paperclip_defaults = {
    storage: :s3,
    s3_region: ENV["BUCKETEER_REGION"],
    s3_credentials: {
      bucket: ENV["BUCKETEER_BUCKET_NAME"],
      access_key_id: ENV["BUCKETEER_AWS_ACCESS_KEY_ID"],
      secret_access_key: ENV["BUCKETEER_AWS_SECRET_ACCESS_KEY"],
    },
  }
end
