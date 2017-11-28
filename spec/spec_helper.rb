require "simplecov"
require "pry"
require "webmock/rspec"

# Run code coverage and save to CI's artifacts directory if we're on CircleCI
if ENV["CI"]
  SimpleCov.coverage_dir(File.join(ENV["CIRCLE_ARTIFACTS"], "coverage"))
end

SimpleCov.start("rails") do
  # To exclude files from coverage analysis:
  # add_filter "/app/path/to/directory/"
end

WebMock.disable_net_connect!(allow_localhost: true)

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.example_status_persistence_file_path = "tmp/examples.txt"
  config.order = :random

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

  if ENV["PRE_DEPLOY_TEST"] == "true"
    config.filter_run :driving
  else
    config.filter_run_excluding :driving
  end

  config.run_all_when_everything_filtered = true

  config.before(:each) do
    stub_request(:get, /api.opencagedata.com/).
      to_return(status: 200, body: {
        results: [],
        status: {
          code: 200,
          message: "OK",
        },
      }.to_json, headers: {})
  end

  if ENV["CI"]
    config.before(:example, :focus) do |example|
      raise(
        "#{example.description} was committed with `:focus`",
      )
    end
  end
end
