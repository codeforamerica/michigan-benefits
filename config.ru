# frozen_string_literal: true

# This file is used by Rack-based servers to start the application.

require_relative "config/environment"

if Rails.env.production?
  DelayedJobWeb.use Rack::Auth::Basic do |username, password|
    # rubocop:disable LineLength
    username_match = ActiveSupport::SecurityUtils.variable_size_secure_compare(ENV["ADMIN_USER"], username)
    password_match = ActiveSupport::SecurityUtils.variable_size_secure_compare(ENV["ADMIN_PASSWORD"], password)
    # rubocop:enable LineLength

    username_match && password_match
  end
end

run Rails.application
