# frozen_string_literal: true

require "find_chrome"

Capybara.register_driver :chrome do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    chromeOptions: {
      binary: FindChrome.binary,
    },
  )

  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    desired_capabilities: capabilities,
    driver_path: FindChrome.driver,
  )
end
