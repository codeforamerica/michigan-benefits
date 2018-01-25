# frozen_string_literal: true

source "https://rubygems.org"

ruby "~> 2.5.0"

gem "activemodel_type_symbol"
gem "administrate"
gem "attr_encrypted"
gem "auto_strip_attributes"
gem "aws-sdk"
gem "bourbon", "~> 4.2.0" # to keep in sync with getcalfresh
gem "capybara"
gem "delayed_job_active_record"
gem "delayed_job_web"
gem "devise"
gem "devise-otp",
  git: "https://github.com/pynixwang/devise-otp",
  ref: "a181217a2d436de7ebb9a278bcb326bbddefa514"
gem "faraday"
gem "geocoder"
gem "good_migrations"
gem "high_voltage"
gem "jquery-rails"
gem "lograge"
gem "mimemagic"
gem "mini_magick"
gem "neat", "~> 1.8" # to keep in sync with getcalfresh
gem "pdf-forms"
gem "pg", "~> 0.21"
gem "prawn"
gem "pry-rails"
gem "puma"
gem "rails", "~> 5.1"
gem "responders"
gem "route_downcaser"
gem "ruby-filemagic"
gem "sass-rails"
gem "selenium-webdriver", "3.4.3"
gem "slack-ruby-client"
gem "strong_migrations"
gem "token_phrase"
gem "twilio-ruby"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

gem "uglifier", ">= 1.3.0"

group :test do
  gem "axe-matchers"
  gem "database_cleaner"
  gem "launchy"
  gem "pdf-reader"
  gem "rails-controller-testing"
  gem "shoulda-matchers"
  gem "timecop"
  gem "webmock"
end

group :development, :test do
  gem "awesome_print", require: false
  gem "brakeman", require: false
  gem "bundler-audit"
  gem "climate_control"
  gem "codeclimate-test-reporter"
  gem "dotenv-rails" # useful for when running dev server w/o foreman
  gem "factory_bot_rails"
  gem "listen"
  gem "mailcatcher"
  gem "pry-byebug"
  gem "rspec-rails"
  gem "rspec_junit_formatter"
  gem "rubocop-rspec", require: false
  gem "simplecov"
end

group :production do
  gem "sentry-raven"
end

group :development do
  gem "overcommit"
end
