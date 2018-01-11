require "mkmf"

class FindChrome
  def self.binary
    search(chrome_paths, for_binary_named: "Chrome")
  end

  def self.driver
    search(chromedriver_paths, for_binary_named: "Chromedriver")
  end

  def self.search(paths, for_binary_named:)
    found = paths.select { |path| File.executable? path }
    return found.first if found.any?
    raise "#{for_binary_named} not found on system"
  end

  def self.chrome_paths
    @_chrome_paths ||= [
      "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome",
      "/opt/google/chrome/chrome",
      ENV["GOOGLE_CHROME_BIN"],
      ENV["CHROME_PATH"],
      find_executable("chrome"),
    ].compact
  end

  def self.chromedriver_paths
    @_chromedriver_paths ||= [
      "/usr/local/bin/chromedriver",
      "/usr/lib/chromium-browser/chromedriver",
      "/app/.chromedriver/bin/chromedriver",
      ENV["CHROMEDRIVER_PATH"],
      find_executable("chromedriver"),
    ].compact
  end
end
