# frozen_string_literal: true

require "simplecov"
require "pry"

# Run code coverage and save to CircleCI's artifacts directory if we're on CircleCI
if ENV["CI"]
  SimpleCov.coverage_dir(File.join(ENV["CIRCLE_ARTIFACTS"], "coverage"))
end

SimpleCov.start "rails"

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.example_status_persistence_file_path = "tmp/examples.txt"

  config.filter_gems_from_backtrace \
    "actionpack",
    "activesupport",
    "actionview",
    "capybara",
    "climate_control",
    "rack",
    "railties",
    "responders"

  config.filter_run :focus
  config.run_all_when_everything_filtered = true

  if ENV["CI"]
    config.before(:example, :focus) do |example|
      raise "#{example.description} was committed with `:focus` and should not have been"
    end
  end
end
