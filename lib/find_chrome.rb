# frozen_string_literal: true

require "mkmf"

class FindChrome
  CHROME_PATHS = [
    "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome",
    "/opt/google/chrome/chrome",
    ENV["CHROME_PATH"],
    find_executable("chrome"),
  ].compact.freeze

  CHROMEDRIVER_PATHS = [
    "/usr/local/bin/chromedriver",
    ENV["CHROMEDRIVER_PATH"],
    find_executable("chromedriver"),
  ].compact.freeze

  def self.binary
    found = CHROME_PATHS.select { |path| File.executable? path }
    return found.first if found.any?
    raise "Chrome not found on system"
  end

  def self.driver
    found = CHROMEDRIVER_PATHS.select { |path| File.executable? path }
    return found.first if found.any?
    raise "Chromedriver not found on system"
  end
end
