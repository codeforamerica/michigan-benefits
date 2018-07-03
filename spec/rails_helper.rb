ENV["RAILS_ENV"] ||= "test"
require "spec_helper"
require File.expand_path("../config/environment", __dir__)
require "rspec/rails"
require "capybara/rails"
require "capybara/rspec"
require "selenium/webdriver"
require "axe/rspec"
require "devise"
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

Capybara.javascript_driver = :selenium_chrome_headless
Capybara.default_max_wait_time = 0.2

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = false
  config.include AbstractController::Translation

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do |example|
    js_driver_enabled = example.metadata[:js] ||
      (example.metadata[:a11y] && ENV["RUN_ACCESSIBILITY_SPECS"])

    DatabaseCleaner.strategy = if js_driver_enabled
                                 :truncation
                               else
                                 :transaction
                               end

    DatabaseCleaner.start
  end

  config.before :all, type: :feature do
    stub_request(:get, /example\.com\/images/).
      to_return(File.new("spec/fixtures/test_remote_image.jpg"))

    Delayed::Worker.delay_jobs = false
  end

  config.before :all, :a11y do
    if ENV["RUN_ACCESSIBILITY_SPECS"]
      Capybara.current_driver = Capybara.javascript_driver
    end
  end

  config.after :all, type: :feature do
    Delayed::Worker.delay_jobs = true
  end

  config.after :each, type: :feature do
    ActionMailer::Base.deliveries.clear
  end

  config.after(:each) do
    DatabaseCleaner.clean
    FakeTwilioClient.clear!
  end

  config.after :all, :a11y do
    if ENV["RUN_ACCESSIBILITY_SPECS"]
      Capybara.use_default_driver
    end
  end

  config.before :all, :single_app_flow do
    ENV["SINGLE_PROGRAM_APPLICATIONS_ENABLED"] = "true"
  end

  config.after :all, :single_app_flow do
    ENV["SINGLE_PROGRAM_APPLICATIONS_ENABLED"] = "false"
  end

  config.infer_spec_type_from_file_location!
  config.include FeatureHelper, type: :feature
  config.include SnapApplicationFormHelper, type: :feature
  config.include MedicaidApplicationFormHelper, type: :feature
  config.include Warden::Test::Helpers, type: :feature
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include GenericHelper
  config.include BackgroundJobs
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
