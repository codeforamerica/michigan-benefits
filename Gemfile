# frozen_string_literal: true

source "https://rubygems.org"

ruby "~> 2.5.1"

gem "activemodel_type_symbol"
gem "administrate"
gem "administrate-field-enum"
gem "attr_encrypted"
gem "auto_strip_attributes"
gem "aws-sdk"
gem "bootsnap", require: false
gem "bourbon", "~> 5.1.0" # to keep in sync with getcalfresh
gem "browser"
gem "capybara"
gem "delayed_job_active_record"
gem "delayed_job_web", ">= 1.4.3"
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
gem "nokogiri", ">= 1.8.2"
gem "pdf-forms"
gem "pg", "~> 1.1"
gem "phonelib"
gem "prawn"
gem "pry-rails"
gem "puma"
gem "rails", "~> 5.2"
gem "responders"
gem "route_downcaser"
gem "ruby-filemagic"
gem "sass-rails", "~> 5.0"
gem "sinatra"
gem "slack-ruby-client"
gem "sprockets", "~> 3.7.2"
gem "token_phrase"
gem "twilio-ruby"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

gem "uglifier", ">= 1.3.0"

group :test do
  gem "axe-matchers", "~> 1.3.4"
  gem "capybara-selenium"
  gem "chromedriver-helper"
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
  gem "dotenv-rails" # useful for when running dev server w/o foreman
  gem "factory_bot_rails"
  gem "listen"
  gem "pry-byebug"
  gem "rspec-rails"
  gem "rspec_junit_formatter"
  gem "rubocop", require: false
  gem "rubocop-rspec", require: false
  gem "spring"
  gem "spring-commands-rspec"
  gem "spring-commands-rubocop"
end

group :production do
  gem "sentry-raven"
end

group :development do
  gem "overcommit"
end
