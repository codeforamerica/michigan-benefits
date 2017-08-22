# frozen_string_literal: true

require "find_chrome"

Capybara.register_driver :headless_chrome do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    chromeOptions: {
      args: %w[headless disable-gpu],
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
