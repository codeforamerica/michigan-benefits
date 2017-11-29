Rails.application.configure do
  config.cache_classes = true
  config.eager_load = true
  config.public_file_server.enabled = true
  config.public_file_server.headers = {
    "Cache-Control" => "public, max-age=3600",
  }
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false
  config.action_dispatch.show_exceptions = false
  config.action_controller.allow_forgery_protection = false
  config.action_mailer.perform_caching = false
  config.action_mailer.delivery_method = :test
  config.action_view.raise_on_missing_translations = true
  config.active_support.deprecation = :stderr
  config.assets.debug = true

  config.action_mailer.default_url_options = {
    host: "example.com",
  }
end
