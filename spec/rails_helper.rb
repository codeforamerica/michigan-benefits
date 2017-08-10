# frozen_string_literal: true

ENV["RAILS_ENV"] ||= "test"
require "spec_helper"
require File.expand_path("../../config/environment", __FILE__)
require "rspec/rails"

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

headless_capybara = true
require "capybara/rails"
require "capybara/rspec"

if headless_capybara
  require "capybara/poltergeist"
  Capybara.javascript_driver = :poltergeist
else
  Capybara.register_driver :chrome do |app|
    Capybara::Selenium::Driver.new(app, browser: :chrome)
  end
  Capybara.javascript_driver = :chrome
end

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = false
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end
  config.before(:each) do |example|
    DatabaseCleaner.strategy = example.metadata[:js] ? :truncation : :transaction
    DatabaseCleaner.start
  end
  config.after(:each) do
    DatabaseCleaner.clean
    FakeTwilioClient.clear!
  end

  config.infer_spec_type_from_file_location!

  config.include FeatureHelper, type: :feature
  config.include GenericHelper
  config.include StepHelper
end
