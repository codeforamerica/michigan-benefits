# frozen_string_literal: true

source 'https://rubygems.org'

ruby '2.4.1'

gem 'aws-sdk'
gem 'bourbon', '~> 4.2.0' # to keep in sync with getcalfresh
gem 'haml', '~> 5.0'
gem 'jquery-rails'
gem 'neat', '~> 1.8' # to keep in sync with getcalfresh
gem 'paperclip', '~> 5.0.0'
gem 'pdf-forms'
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.0'
gem 'rails', '~> 5.1'
gem 'responders'
gem 'sass-rails', '~> 5.0'
gem 'sorcery'
gem 'twilio-ruby'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

gem 'uglifier', '>= 1.3.0'

group :test do
  gem 'database_cleaner'
  gem 'faker'
  gem 'rails-controller-testing'
end

group :development, :test do
  gem 'capybara'
  gem 'capybara-accessible'
  gem 'climate_control'
  gem 'haml-lint', require: false
  gem 'poltergeist'
  gem 'pry-rails'
  gem 'rspec-rails'
  gem 'rubocop-rspec', require: false
end

group :development do
  gem 'citizen-scripts', git: 'https://github.com/citizencode/citizen-scripts'
end
