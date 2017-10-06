# frozen_string_literal: true

require "mkmf"

class FindChrome
  CHROME_PATHS = [
    "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome",
    "/opt/google/chrome/chrome",
    ENV["GOOGLE_CHROME_BIN"],
    ENV["CHROME_PATH"],
    find_executable("chrome"),
  ].compact.freeze

  CHROMEDRIVER_PATHS = [
    "/usr/local/bin/chromedriver",
    "/usr/lib/chromium-browser/chromedriver",
    ENV["CHROMEDRIVER_PATH"],
    find_executable("chromedriver"),
  ].compact.freeze

  def self.binary
    search(CHROME_PATHS, for_binary_named: "Chrome")
  end

  def self.driver
    search(CHROMEDRIVER_PATHS, for_binary_named: "Chromedriver")
  end

  def self.search(paths, for_binary_named:)
    found = paths.select { |path| File.executable? path }
    return found.first if found.any?
    raise "#{for_binary_named} not found on system"
  end
end
