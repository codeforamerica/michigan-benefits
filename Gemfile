# frozen_string_literal: true

source "https://rubygems.org"

ruby "2.4.1"

gem "administrate"
gem "attr_encrypted"
gem "aws-sdk"
gem "bourbon", "~> 4.2.0" # to keep in sync with getcalfresh
gem "delayed_job_active_record"
gem "faraday"
gem "jquery-rails"
gem "neat", "~> 1.8" # to keep in sync with getcalfresh
gem "paperclip", "~> 5.0.0"
gem "pdf-forms"
gem "pg", "~> 0.18"
gem "puma", "~> 3.0"
gem "rails", "~> 5.1"
gem "responders"
gem "sass-rails", "~> 5.0"
gem "sfax",
  git: "https://github.com/codeforamerica/sfax",
  ref: "da88847faaf5ab51255e4d7e47d76493d05113b1"
gem "twilio-ruby"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

gem "uglifier", ">= 1.3.0"

group :test do
  gem "database_cleaner"
  gem "faker"
  gem "launchy"
  gem "pdf-reader"
  gem "rails-controller-testing"
end

group :development, :test do
  gem "awesome_print", require: false
  gem "bundler-audit"
  gem "capybara"
  gem "climate_control"
  gem "codeclimate-test-reporter"
  gem "factory_girl_rails"
  gem "listen"
  gem "mailcatcher", "~> 0.2"
  gem "poltergeist"
  gem "pry-rails"
  gem "rspec-rails"
  gem "rspec_junit_formatter"
  gem "rubocop-rspec", require: false
  gem "simplecov"
end

group :development do
  gem "overcommit"
end
