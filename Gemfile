source "https://rubygems.org"

#ruby "2.3.1"

gem "awesome_print"
gem "bourbon"
gem "coffee-rails", "~> 4.1.0"
gem "fortitude"
gem "jbuilder", "~> 2.0"
gem "jquery-rails"
gem "neat", "~> 1.8"
gem "pg", "~> 0.18"
gem "puma", "~> 3.0"
gem "rails", "~> 5.0"
gem "rake"
gem "responders"
gem "sass-rails", "~> 5.0"
gem "sorcery"
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby] # Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "uglifier", ">= 1.3.0"

# from gcf
# gem 'pdf-forms'
# gem 'prawn'
# gem 'StreetAddress', :require => "street_address"
# gem 'twilio-ruby'

group :test do
  gem "database_cleaner"
  gem "faker"
  gem "rails-controller-testing"
  gem "selenium-webdriver"
end

group :development, :test do
  gem "byebug", platform: :mri
  gem "capybara"
  gem 'capybara-accessible'
  gem "climate_control"
  gem "launchy"
  gem "poltergeist"
  gem "rspec-rails"
  gem "rspec_junit_formatter"

  # from gcf
  # gem 'pdf-inspector'
end

group :development do
  gem "citizen-scripts", git: "git@github.com:citizencode/citizen-scripts.git"
  gem "html2fortitude"
  gem "listen", "~> 3.0.5"
  gem "meta_request"
  gem "pivotal_git_scripts"
  gem 'pry-rescue'
  gem 'pry-stack_explorer'
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "web-console"
  gem "xray-rails"
end
