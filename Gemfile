# frozen_string_literal: true

source "https://rubygems.org"

ruby "2.4.2"

gem "activemodel_type_symbol"
gem "administrate"
gem "attr_encrypted"
gem "auto_strip_attributes"
gem "aws-sdk"
gem "bourbon", "~> 4.2.0" # to keep in sync with getcalfresh
gem "capybara"
gem "delayed_job_active_record"
gem "delayed_job_web"
gem "faraday"
gem "jquery-rails"
gem "mimemagic"
gem "mini_magick"
gem "neat", "~> 1.8" # to keep in sync with getcalfresh
gem "pdf-forms"
gem "pg", "~> 0.18"
gem "prawn"
gem "puma"
gem "rails", "~> 5.1"
gem "responders"
gem "ruby-filemagic"
gem "sass-rails", "~> 5.0"
gem "selenium-webdriver", "3.4.3"
gem "sfax",
  git: "https://github.com/codeforamerica/sfax",
  ref: "da88847faaf5ab51255e4d7e47d76493d05113b1"
gem "token_phrase"
gem "twilio-ruby"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

gem "uglifier", ">= 1.3.0"

group :test do
  gem "database_cleaner"
  gem "launchy"
  gem "pdf-reader"
  gem "rails-controller-testing"
  gem "timecop"
  gem "webmock"
end

group :development, :test do
  gem "awesome_print", require: false
  gem "bundler-audit"
  gem "climate_control"
  gem "codeclimate-test-reporter"
  gem "dotenv-rails" # useful for when running dev server w/o foreman
  gem "factory_girl_rails"
  gem "listen"
  gem "mailcatcher", "~> 0.2"
  gem "pry-byebug"
  gem "pry-rails"
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
