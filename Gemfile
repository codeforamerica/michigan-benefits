# frozen_string_literal: true

source 'https://rubygems.org'

ruby '2.4.1'

gem 'awesome_print'
gem 'aws-sdk'
gem 'bourbon', '~> 4.2.0' # to keep in sync with getcalfresh
gem 'coffee-rails'
gem 'fortitude'
gem 'haml', '~> 5.0'
gem 'jbuilder', '~> 2.0'
gem 'jquery-rails'
gem 'neat', '~> 1.8' # to keep in sync with getcalfresh
gem 'paperclip', '~> 5.0.0'
gem 'pdf-forms'
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.0'
gem 'rails', '~> 5.1'
gem 'rake'
gem 'responders'
gem 'sass-rails', '~> 5.0'
gem 'sorcery'
gem 'twilio-ruby'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby] # Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'uglifier', '>= 1.3.0'

# from gcf
# gem 'prawn'
# gem 'StreetAddress', :require => "street_address"

group :test do
  gem 'database_cleaner'
  gem 'faker'
  gem 'rails-controller-testing'
  gem 'selenium-webdriver'
end

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'capybara'
  gem 'capybara-accessible'
  gem 'capybara-screenshot'
  gem 'climate_control'
  gem 'haml-lint', require: false
  gem 'launchy'
  gem 'poltergeist'
  gem 'pry-rails'
  gem 'rspec-rails'
  gem 'rspec_junit_formatter'
  gem 'rubocop', require: false
  gem 'rubocop-rspec', require: false

  # from gcf
  # gem 'pdf-inspector'
end

group :development do
  gem 'citizen-scripts', git: 'https://github.com/citizencode/citizen-scripts'
  gem 'guard', require: false
  gem 'guard-rspec', require: false
  gem 'listen', '~> 3.0.5'
  gem 'meta_request'
  gem 'pivotal_git_scripts'
  gem 'pry-rescue'
  gem 'pry-stack_explorer'
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console'
  gem 'xray-rails'
end
