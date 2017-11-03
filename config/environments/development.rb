require Rails.root.join("config/smtp")

Rails.application.configure do
  config.cache_classes = false
  config.eager_load = false
  config.consider_all_requests_local = true

  if Rails.root.join("tmp/caching-dev.txt").exist?
    config.action_controller.perform_caching = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      "Cache-Control" => "public, max-age=172800",
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  config.active_support.deprecation = :log
  config.active_record.migration_error = :page_load
  config.assets.debug = true
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker

  # Customize default host
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_caching = false
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.smtp_settings = {
    address: "127.0.0.1",
    port: 1025,
  }
  config.action_mailer.default_url_options = {
    host: ENV["HOSTNAME_FOR_URLS"],
    protocol: "http",
  }
end
