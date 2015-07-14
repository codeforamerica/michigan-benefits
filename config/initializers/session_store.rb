# Be sure to restart your server when you modify this file.

if Rails.env.production? && !ENV.key?('SECRET_KEY_BASE')
  raise "Please run `rake secret` and configure ENV['SECRET_KEY_BASE'] "\
    "on production, or else session cookies will not be encrypted."
end

Rails.application.config.session_store :cookie_store,
  key: "_#{Rails.application.config.project_slug}_session"
