# frozen_string_literal: true

require "find_chrome"

Capybara.register_driver :chrome do |app|
  profile = Selenium::WebDriver::Chrome::Profile.new
  profile["general.useragent.override"] =
    "Mozilla/5.0 (X11; Linux x86_64; MichiganBenefits.org) "\
    "AppleWebKit/537.36 (KHTML, like Gecko) "\
    "Chrome/60.0.3112.101 Safari/537.36"

  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    profile: profile,
    chromeOptions: {
      binary: FindChrome.binary,
    },
  )

  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    desired_capabilities: capabilities,
    driver_path: FindChrome.driver,
    profile: profile,
  )
end
